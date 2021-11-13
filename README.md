# Kubernetes testing stand repo
Status: Beta. Not all features are added.
This repo writing for learning purpose: virtualization technology, Ansible, Kubernetes, CI/CD practises, Monitoring, Logging and other Linux administration and DevOps practices.
## Requirements:
- Installed VirualBox
- Installed Vagrant
## Owerview
This repository may not 
- Configure Vagrantfile for your purposes. (Ansible playbooks writes for using only Ubuntu v20.04, with other distributions it's will not work.)
- Configure Ansible inventory file using hostnames of created hosts.
- Configure Ansible variables. Default variables path ./provisioning/ansible/group_vars/all/all.yml (Also this directory contains encrypted file secret.yml. If you want start playbook without secret you are needed to define following variables[pookie link](#pookie) )
- Configure Ansible roles in ./provisioning/ansible/kubernetes.yml

<a name="pookie">Secret Variables</a>
default_password: "13011988"
email: "jeronimo8008@gmail.com"

#### prometheus-operator
alertmanagerconfig_namespace: ""
smtp_auth_password: ""
smtp_auth_username: ""
smtp_auth_identity: ""
slack_webhook: ""
slack_username: ""
slack_channel: ""
