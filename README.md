# cloud-strategy-infrastructure

## GCP Initial Setup

### Create project

```
gcloud projects create cloud-strategy-poc --name="Cloud Strategy POC"
```

### Link billing account to project

```
gcloud beta billing projects link cloud-strategy-poc --billing-account $BILLING_ACCOUNT
```

### Create service account and grant access

```
gcloud config set core/project cloud-strategy-poc

gcloud iam service-accounts create tf-cicd

gcloud projects add-iam-policy-binding cloud-strategy-poc --member serviceAccount:tf-cicd@cloud-strategy-poc.iam.gserviceaccount.com --role roles/owner
```

### Creating and downloading the access key

```
gcloud iam service-accounts keys create access.json --iam-account=tf-cicd@cloud-strategy-poc.iam.gserviceaccount.com
```

### Create Bucket for storing Terraform State

```
gsutil mb -p cloud-strategy-poc -c Standard -l europe-west6 -b on gs://cloud-strategy-poc-terraform-state
```

## AWS Initial Setup

### Create Bucket for storing Terraform State

```
aws s3api create-bucket --bucket "cloud-strategy-poc-terraform-state" --region "eu-central-1" --create-bucket-configuration LocationConstraint="eu-central-1"
```

## Azure Initial Setup

### Create Bucket for storing Terraform State

```
az group create --name $RESOURCE_GROUP_NAME --location eastus
```
