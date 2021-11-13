# Kubernetes testing stand repo.
Status: Beta. Not all features are added.  
This repo writing for learning purpose: virtualization technology, Ansible, Kubernetes, CI/CD practises, Monitoring, Logging and other Linux administration and DevOps practices. 
## Overview
### Host machine requirements
- Min 24Gb ram, 8 threads, 4 cpu, 200Gb ssd drive
- Installed VirualBox
- Installed Vagrant
### Vagrant requirements
- Min 2Gb ram for control-plane nodes, 2 cpu
- Min 4Gb ram for worker nodes, 2 cpu
### Installations
#### Preconfig
1. Configure Vagrantfile for your purposes. HW resouces, hostnames. I do not recommend change ip subnet, i may hardcoded somethere it (Solution: use 'grep -R "192.168.88*" ./provisioning/ansible' and set desired values).
2. Configure Ansible inventory file using hostnames of created hosts.
3. Configure Ansible variables. Default variables path: ./provisioning/ansible/group_vars/all/all.yml (Also this directory mast contains by ansible-vault file "secret.yml" where you are needd to define [following variables](#secrets). By default public repo contains uncrypted secret.yml file. )
#### Kubernetes
Warning: Ansible playbooks support only Ubuntu 20.04.
Steps for run ansible playbook
2. Configure Ansible variables for roles. Path: ./provisioning/ansible/kubernetes.yml
3. Run ansible playbook kubernetes.yml.
#### Postgresql
Warning: Ansible playbooks support only Ubuntu 20.04.
1. Configure Ansible variables for roles. Path: ./provisioning/ansible/postgresql.yml
2. Run ansible playbook.

## <a name="secrets">Secret Variables</a>  
- default_password: "examplePass"  
- email: "exampleEmail"  
#### prometheus-operator
- alertmanagerconfig_namespace: ""  
- smtp_auth_password: ""  
- smtp_auth_username: ""  
- smtp_auth_identity: ""  
- slack_webhook: ""  
- slack_username: ""  
- slack_channel: ""  
