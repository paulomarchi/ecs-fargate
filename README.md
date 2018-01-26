![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)

# ECS Fargate - Route53 - Cloudwatch - VPC - ALB - EIP - IAM

The project was created to learn more about ECS Fargate using Terraform tools. All the infrastructure are performing in Amazon Web Services.
Feel free to contribute.

## Requeriments
   * **AWS Account:** https://console.aws.amazon.com
   * **AWS Cli:** http://docs.aws.amazon.com/pt_br/cli/latest/userguide/installing.html
   * **Terraform:** https://www.terraform.io/

## Running the example

### AWS Profile
#### Create a aws profile informando your access key and secret key
````
$ aws configure --profile <name-profile> 
````
#### Create a keypair
```
$ aws --profile <name-profile>  ec2 create-key-pair --key-name <key-pair-name> --query 'KeyMaterial' --output text > <key-pair-name>.pem
```

### Reoute53
#### Access aws console 
```
You need a dns zone pre-registered in route53
```
### Terraform
#### Download and install modules for the configuration
```
$ terraform init
```
#### Generate and show an execution plan
```
$ terraform plan -var-file="terraform.tfvars"
```

#### Builds or changes infrastructure
```
$ terraform apply -var-file="terraform.tfvars"
```
#### Read an output from a state file
```
$ terraform output
```

### URI
```
$ http://<your-project>.<your_domain>
```
## Docs
 * **Terraform Getting Started:** https://www.terraform.io/intro/index.html)
 * **Fargate:** [Getting Started](https://aws.amazon.com/pt/blogs/aws/aws-fargate/)

# TODO
* **Create Codepipeline**
* **Create Codebuild**
