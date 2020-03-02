# Data Transfer Pod

**WORK IN PROGRESS**

*Better documentation coming soon.*

This is a Helm deployment that starts between 1..N containers, each representing a different data transfer protocol. 

All containers are mounted to the same PVC, the idea is that users can easily move data to and from Kubernetes clusters and multiple servers with a single deployment.

Currently, only interactive mode is supported. In the future, these transfers will be able to happen in the background and be used by other applications.

Right now, the supported protocols are:

 - Globus Connect Personal
 - iRODS
 - Name-Defined Networking(NDN)
 - Aspera
 - S3
 - MinIO
 - SRA Toolkit(NCBI)
 - Local transfers(to/from the user's local machine)

## Installation

First, install dependencies:
 - Helm 3(2 may also work)
 - kubectl

Make sure both Helm and kubectl are configured properly with the Kubernetes cluster of your choosing.

The K8s cluster MUST have either a valid PVC or storage class. If a valid PVC does not exist, here are some example instructions to set up a NFS storage class:

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

### Secrets

On deployment, the Data Transfer Pod will automatically authenticate your credentials with the associated protocol(s).

*This is not required for Interactive Mode, but necessary for some background transfers.*

In [values.yaml](https://github.com/cbmckni/dtp/blob/master/helm/values.yaml), you must either enable/disable the secrets for each protocol. 

Next, enter your credentials in [config](https://github.com/SciDAS/dtp/blob/master/helm/config).

Finally, run [gen-secret](https://github.com/SciDAS/dtp/blob/master/helm/gen-secret): 

`./helm/gen-secret`

Go over your secrets to make sure they are entered correctly(some will be base64 encoded and will not be human-readable).

## Usage

To deploy the DTP, run [start](https://github.com/cbmckni/dtp/blob/master/start).

`./start`

It should output 'DTP started.' when finished.

To interact with any of the running containers, run [interact](https://github.com/cbmckni/dtp/blob/master/interact).

`./interact`

To pass commands to containers in the background(if an application/script wants to use a running DTP, for example), use [background](https://github.com/SciDAS/dtp/blob/master/background)

`./background <--container1> 'command1' <--container2> 'command2' ....`

ex: `./background --dtp-irods 'ils' --dtp-aws 'aws s3api list-buckets'`

## Delete

To destroy the DTP when all transfers are complete, run `helm uninstall dtp`

That's it for now!




