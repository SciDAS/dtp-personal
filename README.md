# Data Transfer Pod

**WORK IN PROGRESS**

*Better documentation coming soon.*

This is a Helm deployment that starts between 1..N containers, each representing a different data transfer protocol. 

All containers are mounted to the same PVC, the idea is that users can easily move data to and from Kubernetes clusters and multiple servers with a single deployment.

Currently, only interactive mode is supported. In the future, these transfers will be able to happen in the background and be used by other applications.

Right now, the supported protocols are:

 - iRODS
 - Name-Defined Networking(NDN)
 - Aspera
 - S3
 - MinIO
 - Local transfers(from the user's local machine)

### Installation

First, install dependencies:
 - Helm 3(2 may also work)
 - kubectl

Make sure both Helm and kubectl are configured properly with the Kubernetes cluster of your choosing.

The K8s cluster MUST have either a valid PVC or storage class. If a valid PVC does not exist, here are some example instructions to set up a NFS storage class:

#### Create NFS StorageClass (optional)

Update Helm's repositories(similar to `apt-get update)`:

`helm repo update`

Next, install a NFS provisioner onto the K8s cluster to permit dynamic provisoning for **10Gb**(example) of persistent data:

`helm install kf stable/nfs-server-provisioner \`

`--set=persistence.enabled=true,persistence.storageClass=standard,persistence.size=10Gi`

Check that the `nfs` storage class exists:

`kubectl get sc`

Make sure to edit the [values.yaml](https://github.com/cbmckni/dtp/blob/master/helm/values.yaml) file later to use this storage class and size!

### Usage

These are the steps necesary to use the Data Transfer Pod.

First, go into [values.yaml](https://github.com/cbmckni/dtp/blob/master/helm/values.yaml).

Configure the PVC section to either create a new PVC or use an existing one. **One must be enabled, the other must be disabled.**

Enable/Disable each data transfer protocol to your needs by changing them to `true` or `false`.

Don't worry about secrets for now, full support will come later.

#### Deploy and Interact

To deploy the DTP, run [start.sh](https://github.com/cbmckni/dtp/blob/master/start.sh).

It should output 'DTP started.' when finished.

To interact with any of the running containers, run [interact.sh](https://github.com/cbmckni/dtp/blob/master/interact.sh).

#### Delete

To destroy the DTP when all transfers are complete, run 'helm uninstall dtp`

That's it for now!




