# Halftime Sensor Lab

## Description:

The purpose of this lab is to dive deep into the capabilities of the Wiz Sensor, both as a defender and an attacker.

## Setup:

1. Copy the `.env.template` file

```sh
cp .env.template .env
```

2. Edit the `.env` file and add the credentials

   - For registry credentials, navigate [here](https://app.wiz.io/tenant-info/general).
   - For the K8s service account, navigate [here](https://app.wiz.io/settings/service-accounts/new) and select _"Complete Kubernetes Integration"_

3. Set your environment

```sh
source .env
```

4. Change into the Terraform directory

```sh
cd terraform
```

5. Run Terraform

```sh
terraform init
terraform apply
```

6. Generate the lab guide from the Terraform output

```sh
cd ../scripts/
./generate_lab_guide.sh
```

7. Navigate to the Lab guide in VSCode in Preview (right click > Open Preview)

## Lab Prequisites:

- The lab requires the following:
  - SSH (for the attacker C2 & post-exploitation)
  - Web Browser (Chrome, Firefox, Safari, or similar)
  - Wiz Tenant w/ AWS Connector Setup

## Dependencies:

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Helm](https://helm.sh/docs/intro/install/)
- gettext

The `generate_lab_guide.sh` script uses `envsubst` from the `gettext` package. You can install it with Homebrew:

```sh
brew install gettext
brew link --force gettext
```
