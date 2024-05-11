# Final project: Infrastructure for Microservices with Terraform

This project uses the concepts acquired during the course to create an infrastructure for microservices using Terraform version `1.7.5.`

## Project description

The goal of this project is to design and deploy a scalable and automated infrastructure to support microservices. Terraform is used to define infrastructure as code (IaC), enabling efficient and reproducible management of the microservices execution environment.

## Requirements

* Terraform v1.7.5 installed
* Properly configured AWS credentials
* AWS CLI configured with access keys

## Use

1. Clone this repository locally

```bash
git clone https://github.com/AEIS-FIS-EPN/william-zapata-aws-infra-microservices.git
```

2. Navigate to the directory containing the Terraform configuration files

```bash
cd william-zapata-aws-infra-microservice
```

3. Initialize Terraform

```bash
terraform init
```

4. Validates if the file and its content are correct

```bash
terraform validate
```

5. Review the Terraform plan to understand the changes that will be applied

```bash
terraform plan
```

6. Apply the Terraform configuration to create or update resources

```bash
terraform apply
```

***Confirm the changes when prompted by Terraform***

---

## Destroy

When you no longer need the infrastructure, you can destroy it using the following command

```bash
terraform destroy
```

---

### Authors

This project was created by William Zapata.

## License

This project is licensed under the [MIT]. See the LICENSE file for more details.