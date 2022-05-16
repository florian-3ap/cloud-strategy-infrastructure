# cloud-strategy-infrastructure

## GCP Initial Setup

```
cd GCP/initial-setup

terraform init

terraform apply -var='project_name=Cloud Strategy POC' -var="project_id=cloud-strategy-poc"
```

## AWS Initial Setup

### Create Bucket for storing Terraform State

```
cd AWS/initial-setup

terraform init

terraform apply -var='project_name=Cloud Strategy POC'
```

## Azure Initial Setup

```
cd AZ/initial-setup

terraform init

terraform apply -var='project_name=cloud-strategy-poc'
```
