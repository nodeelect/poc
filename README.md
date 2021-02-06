
Proof of Concept

# General Idea

Problem description:
There is a new edge received somewhere in the field and this needs to connected to the company IT infrastructure.
The edge was send from hardware manufacturer with a preloaded image.
The Image is not containing any access keys, because the edge could be lost while shipping and then the access keys are also lost.
In addition there is no PKI Infrastructure which could be used.

Additional Issues:
There are often no Keyboard and skilled People on side to activate the edge on the device.

Solution:
The Edge will open a registration request on a static url and a remote service technician or field service engineer can register the edge to a tenant.
The registration will provide a certificate and basic settings. With the certificate the edge can connect to the tenant backend it infrastructure e.g. and pick their workload.
IT Infrastructure could be anything dependent from the edge OS and installed services. It could be for example an Azure IOT Hub. The certificate is then used to do s self registration via the Azure IoT DPS. 
It could also be a Git Repo in case of an GitOps based deployment of workload, or whatever you want.

## Technology (Draft)

POC/MVP basically shell scripts (no http interaction).

Backend:
* App Server
    * REST (Python Flask)
    * WebSockets
    * EasyRSA for Certificate Management
* Website 
    * Single Page Web Application with VUE JS
* Hosting
    * Docker / Kubernetes

Edge Client
    * Python

## non functional Requirements
No certificate is stored on a server of this project. All services should run without persistence and in the best case inside containers which are destroyed after the registration session.

# Functionality description
This is a draft to define the POC / MVP. More detailed description will be found in other repos if the POC is successful.
## Tenant
The tenant is the owner of the edge. That could be a company or a department. 
There is no link or hierarchy between tenants. 

The creation of a Tenant could be made by an provider, but also by the tenant itself.
### create tenant
* basically a root certificate for the organization
* some metadata like 
    * minimum validity of an edge registration certificate
    * applicable tags and values e.g.:
        * "region": "emea"
        * "region": "us"
        * "region": "asia"

    * default settings applied to all edges e.g.:
        * "gitops_active": "true"
        * "gitops_repo": "https://github.com/demo/k8s.git"
        * "gitops_branch": "main"

        * "management_server": "https://hawkbit.example.com"

        * "azure_iothub": "https:...."



### create registration license
This is the main package used later on by the People who doing the registration process. 
Basically it's a AES256 encrypted package which contains
* an issuer certificate (should be derived from main to make it revokable)
* metadata like organization unit, username e.g.
* defaults of the tenants


Problems to solve: 
* how can we revoke and registration license without revoking the created certificates --> maybe having two 

The registration license could later also contains policies so that the people who do the registration are forced to keep some standards.
In the POC the could modify any setting and default.

#### Steps to get a registration license
1. upload tenant package
2. add issuer or license details e.g. user name
3. set a password
4. (at the server) an issuer certificate is created based on the tenant certificate 
5. download the license package and the public key of the issuer (to revoke it in case of problems)

### revoke edge
Revoking could in theory als be done with an registration license, but to make it working the revocation must be added to the CRL of the tenant. 
If the registration license could also do that we have to think about merging CRLs or using multi level CRLs

Steps
1. upload of registration license
2. public key of the edge
3. existing certificate revocation list
4. download new CRL and provide that to the backend systems

## Field Service

These are the people who will register/activate the edges.
### register edge

Register an edge means bring all the required information to the edge 

Steps:
1. open a registration website
2. upload the registration license
3. enter their AES key which opens the registration package
4. enter the edge serial number (this will be compared with the edge serials in waiting mode)
5. (at server) if the edge is in register mode, it will be shown on the registration website
6. check tags and configs and apply registration
7. (at the server) a new certificate and config file is created for the edge and send to the open channel to the device
8. after the edge received and applied the registration package, you can download the public key for the edge and close the page (key is important to revoke edge later)

## Edge Device
The Edge device will start the registration mode if it is not already registered or if a usb drive is present which contains the "register" command in the command file (a simple text file with a fixed name).

### register
If the edge is in registration mode, they will connect to a registration server mentioned in their profile (which comes with the os).

Steps:
1. It sends a hash of its serial number and metadata like device manufacturer and model
2. after the approval is done, it receives a certificate and default configuration
3. (at the edge) the config will be checked (checksum + cert) and applied 
4. feedback is send to the website and connection is closed
5. (at the edge) - edge will start normal work and reach configured backend

# Dev Env


# Identified Projects to be implemented

This is a list of Projects which needs to be implemented to provide a complete ecosystem

## Edge Client
A debian, snap or rpm package which contains the registration service running on the edge.
It must also check for the "command file" and have local configuration to set the root url, enable disable command file support, registration interval etc.
Maybe also a re-register function.
Think about: Needs to contain a public certificate of the Provider or Tenant to validate the registration package and default settings. 

## Handling CRL to disable edge and registration license
Somehow the CRL must be available for other cervices. Maybe this can be hosted on a static URL

## Sample for Monitoring or Logging, VPN, Azure IoT and SALT Backends
As demo how to use the whole infrastructure