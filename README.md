# infrastructure-as-code-aws

A production-grade AWS infrastructure written in Terraform. The goal was straightforward: build something that reflects how infrastructure is actually managed in teams, not in tutorials.

## What this provisions

A VPC with four subnets spread across two availability zones — two public, two private. An internet gateway with proper routing so only the public subnets have outbound internet access. A web instance in the public subnet behind a security group that allows SSH and HTTP. An S3 bucket with public access blocked. Remote state stored in S3 with DynamoDB locking so concurrent applies don't corrupt each other.

```
eu-west-1
└── VPC 10.0.0.0/16
    ├── public-1a  (10.0.1.0/24)  ── IGW ── internet
    ├── public-1b  (10.0.2.0/24)  ── IGW ── internet
    ├── private-1a (10.0.3.0/24)
    └── private-1b (10.0.4.0/24)

EC2 (t2.micro) in public-1a
S3 bucket (private, versioned state bucket)
DynamoDB table (state locking)
```

## Local development

This project runs against [LocalStack](https://localstack.cloud/) so you can apply the full infrastructure without touching a real AWS account or incurring costs.

**Prerequisites:** Docker, Terraform >= 1.5, LocalStack

```bash
# Start LocalStack
docker run -d -p 4566:4566 localstack/localstack

# Init and apply
terraform init
terraform apply
```

To point this at real AWS, remove the `endpoints` blocks from `main.tf` and `backend.tf` and set valid credentials. Everything else stays the same.

## Structure

```
├── main.tf           # Provider config and LocalStack endpoints
├── backend.tf        # Remote state: S3 + DynamoDB locking
├── vpc.tf            # VPC, subnets, IGW, routing
├── ec2.tf            # Security group, EC2 instance
├── s3.tf             # Application bucket
├── state-backend.tf  # Resources for the remote state backend itself
├── variables.tf      # region, environment, project, instance_type, ami_id
└── outputs.tf        # vpc_id, subnet IDs, bucket name and ARN
```

## Remote state

State is stored in S3 with DynamoDB locking. The backend infrastructure (the state bucket and lock table) is managed by Terraform itself — the classic chicken-and-egg problem solved by applying in two steps: first create the backend resources, then configure and migrate.

```hcl
backend "s3" {
  bucket         = "devops-portfolio-dev-tfstate"
  key            = "dev/terraform.tfstate"
  dynamodb_table = "devops-portfolio-dev-tfstate-locks"
  encrypt        = true
}
```
