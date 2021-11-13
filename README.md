# Kubernetes testing stand repo.
Status: Beta. Not all features are added.  
This repo writing for learning purpose: virtualization technology, Ansible, Kubernetes, CI/CD practises, Monitoring, Logging and other Linux administration and DevOps practices. 
## Host machine requirements
- Min 24Gb ram, 8 threads, 4 cpu, 200Gb ssd drive
- Installed VirualBox
- Installed Vagrant
## Vagrant requirements
- Min 2Gb ram for control-plane nodes, 2 cpu
- Min 4Gb ram for worker nodes, 2 cpu
## Owerview
Warning: Ansible playbooks support only Ubuntu 20.04.
- Configure Vagrantfile for your purposes. (Ansible playbooks writes for using only Ubuntu v20.04, with other distributions it's will not work.)
- Configure Ansible inventory file using hostnames of created hosts.
- Configure Ansible variables. Default variables path: ./provisioning/ansible/group_vars/all/all.yml (Also this directory contains encrypted by ansible-vault file "secret.yml". If you want start playbook without secret you are needed to define following variables[pookie link](#pookie) )
- Configure Ansible variables for roles. Path: ./provisioning/ansible/kubernetes.yml
- If you are using ansible-vault secrest

<a name="pookie">Secret Variables</a>
default_password: "examplePass"  
email: "exampleEmail"  

#### prometheus-operator
alertmanagerconfig_namespace: ""  
smtp_auth_password: ""  
smtp_auth_username: ""  
smtp_auth_identity: ""  
slack_webhook: ""  
slack_username: ""  
slack_channel: ""  
