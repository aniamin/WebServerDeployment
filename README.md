# Setup WebServer using Terraform, Ansible and Docker
Usage: cloud-automation.sh <app> <web_server_environment> <web_num_servers> <web_server_size> <jumpserver> <jumpserver_server_environment> <jumpbox_num_servers> <jumpbox_server_size>"

### Requirements:
- Terraform

### Tools Used:

terraform version
Terraform v0.6.16

To Generate and show an execution plan (dry run):
```
terraform plan
```
To Builds or makes actual changes in infrastructure:
```
terraform apply
```
To inspect Terraform state or plan:
```
terraform show
```
To destroy Terraform-managed infrastructure:
```
terraform destroy
```