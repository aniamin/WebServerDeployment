# Deploy Wordpress Application using Ansible
As ansible playbook will deploy to private subnet which is in private subnet of VPC, the playbook needs to be deployed from any instance inside Public Subnet/Private Subnet or being connected in VPN (VPN instance will be in the public subnet)

From CI server/Jumbox Server/Being conected in VPN we can clone this repository and run the playbook to deploy to web server instances

### Requirements:

- Ansible

### Tools Used:
ansible 1.9.2
config file = /etc/ansible/ansible.cfg

installing ansible in global python
sudo pip install ansible==1.9.1
cd ../ansible

ansible-playbook playbooks/web_server.yml

echo 'Browse Blog at $ELB_DNS'