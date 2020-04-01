

# Edit config

nano config

nano helm/values.yaml

# Generate secrets

./gen-secrets

# Start DTP

./start

# Show Interactive Mode, pull input from iRODS

./interact

# Pull datasets using Background Mode

./background --dtp-sra-toolkit 'fastq-dump -I --split-files SRR649944 --outdir /workspace'

# ./background --dtp-sra-toolkit 'fastq-dump -I --split-files SRR649944 --outdir /workspace' \
#   --dtp-aspera 'ascp -T -l640M -i /home/aspera/.aspera/cli/etc/asperaweb_id_dsa.openssh \    
#   anonftp@ftp.ncbi.nlm.nih.gov:SampleData/Genomes/Genomic_Analysis_Packages/ /workspace/dtp'

# Pull GEMMaker

git clone https://github.com/SystemsGenetics/GEMmaker.git

# Edit config

nano nextflow.config

# Run GEMMaker 

nextflow kuberun systemsgenetics/gemmaker -v rodeo-ceph -c nextflow.config -revision 845d3f24f4ca22f156da41d30d878d9529a18aa4

# Push output to iRODS, S3

./background --dtp-aws 'aws s3 cp --recursive /workspace/cole/output/GEMs s3://scidasbucket/pond-corg-GEMs' --dtp-irods 'iput -r /workspace/cole/output/GEMs /scidasZone/home/cbmckni/pond-corg-GEMs'

# Check

./background --dtp-aws 'aws s3 ls s3://scidasbucket' --dtp-irods 'ils'

# Cleanup 

./background --dtp-aws 'aws s3 rm --recursive s3://scidasbucket/pond-corg-GEMs' --dtp-irods 'irm -r /scidasZone/home/cbmckni/pond-corg-GEMs'




