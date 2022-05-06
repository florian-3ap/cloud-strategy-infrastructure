# cloud-strategy-infrastructure

## GCP Setup

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
