# Data Transfer Pod - Personal


A Data Transfer Pod is a configurable collection of containers, each representing a different data transfer protocol/interface. 

All containers are mounted to the same Persisten Volume Claim(PVC), so users can easily move data to/from Kubernetes clusters and multiple servers with a single deployment.

**USE CASE:** DTP-Personal is intended to be used by a single user, or a single group of users using the name PVC. Users must have the permission to deploy pods using *kubectl*. 

DTP-Personal can be used simply to mount a single container to the PVC to perform basic operations, or to automate complex data movement between a Kubernetes cluster and various endpoints.

For use cases where end users will not have *kubectl* access, or where multiple groups need controlled access to the same PVC, see [DTP-Requests](https://github.com/cbmckni/dtp-requests). 

Right now, the supported protocols are:

 - [Google Cloud SDK](https://cloud.google.com/sdk) 
 - [Globus Connect Personal](https://app.globus.org/)
 - [iRODS](https://irods.org/)
 - [Name-Defined Networking(NDN)](https://named-data.net/)
 - [Aspera CLI](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.2.0/featured_applications/aspera_cli.html)
 - [Amazon Web Services](https://aws.amazon.com/cli/)
 - [MinIO](https://min.io/)
 - [NCBI's SRA Tools](https://github.com/ncbi/sra-tools)
 - [Fast Data Transfer(FDT)](http://monalisa.cern.ch/FDT/)
 - Local transfers(to/from the user's local machine)

## Installation

First, install dependencies:
 - Helm 3(2 may also work)
 - kubectl

Make sure both Helm and kubectl are configured properly with the Kubernetes cluster of your choosing.

The K8s cluster MUST have either a valid PVC or storage class. If a valid PVC or storage class does not exist, here are some example instructions to set up a NFS storage class:

### Create NFS StorageClass (optional)

Update Helm's repositories(similar to `apt-get update)`:

`helm repo update`

Next, install a NFS provisioner onto the K8s cluster to permit dynamic provisoning for **10Gb**(example) of persistent data:

`helm install kf stable/nfs-server-provisioner \`

`--set=persistence.enabled=true,persistence.storageClass=standard,persistence.size=10Gi`

Check that the `nfs` storage class exists:

`kubectl get sc`

Make sure to edit the [values.yaml](https://github.com/cbmckni/dtp/blob/master/helm/values.yaml) file later to use this storage class and size!

## Configuration

These are the steps necesary to use the Data Transfer Pod.

First, go into [values.yaml](https://github.com/cbmckni/dtp/blob/master/helm/values.yaml).

Configure the PVC section to either create a new PVC or use an existing one. 

**One must be enabled, the other must be disabled.**

Enable/Disable each data transfer protocol to your needs by changing them to `true` or `false`.

## Usage

To deploy the DTP, run [start](https://github.com/cbmckni/dtp/blob/master/start).

`./start`

It should output 'DTP started.' when finished.

To interact with any of the running containers, run [interact](https://github.com/cbmckni/dtp/blob/master/interact).

`./interact`

To pass commands to containers in the background(if an application/script wants to use a running DTP, for example), use [background](https://github.com/SciDAS/dtp/blob/master/background).

`./background <--container1> 'command1' <--container2> 'command2' ....`

ex: `./background --dtp-irods 'ils' --dtp-aws 'aws s3api list-buckets'`

*These commands are run in sequence from first-to-last.*

### Local Transfers

To copy data from your local machine to the K8s cluster, use [copy-to](https://github.com/SciDAS/dtp/blob/master/copy-to):

`copy-to /local/path /remote/path`

To copy data from the K8s cluster to your local machine, use [copy-from](https://github.com/SciDAS/dtp/blob/master/copy-from):

`copy-from /remote/path /local/path`

## Delete

To destroy the DTP when all transfers are complete, run `helm uninstall dtp`

That's it for now!




