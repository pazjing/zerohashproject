
# ECS Fragate deploy with Terrafrom

 Configuration in this directory creates set of VPC resources and ECS with Fragate to host the nodejs app container build in this repository

### Main resources created
- VPC network : public subnets, private subnets ans so on
- Security groups for Load balancer and ECS task 
- Load balancer, target group annd listener with HTTP 80 
- ECS with FARGATE capacity
- Task definition to use the nodejs app iamge and mapping port as 3000
- Service cofniguration to launch 2 count and linked to the loadbalancer target group

### Usage
- Configure your local environemnt with AWS CLI
- Configure your local environemnt with valid AWS access crendential
- Execute with below commands

```bash
$ terraform init
$ terraform plan --var-file='test.tfvars'
$ terraform apply --var-file='test.tfvars'
```
- Replace the variable value which suite you in tfvars file or any alternative way
- Copy the load_balancer_dns and open in brower

### Output

| Name | Description |
| ------ | ------ |
| vpc_id | The ID of the VPC|
| load_balancer_dns | Access point to the service in ecs |

### Improvement note
- tfstate file could be store in remote place or use terraform cloud workspace
- log,  metric and  Auto scalling  implement 
