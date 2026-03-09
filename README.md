Here is the step-by-step summary of everything we implemented to build your Dynamic Inventory using Terraform S3 State and Ansible.

Phase 1: Terraform Infrastructure
Remote State: You configured Terraform to store the .tfstate file in an S3 bucket (e.g., inventory-bucket-09032026).
Tagging: You tagged your EC2 instances with a key named Role and values like ubuntu-server or redhat-server.

Phase 2: Ansible Dynamic Inventory
Collection: You installed the required plugin:

ansible-galaxy collection install cloud.terraform

Inventory File: You created inventory.terraform_state.yml to pull data from S3:
yaml
plugin: cloud.terraform.terraform_state

backend_type: s3

backend_config:

  bucket: "inventory-bucket-09032026"
  
  key: "terraform.tfstate"
  
  region: "us-east-1"
  
hostnames: [public_ip]
compose:
  ansible_host: public_ip
keyed_groups:
  - key: tags.Role
    
    prefix: role

Phase 3: Variable Management

Group Variables: You created a group_vars/ directory to automatically assign the correct SSH User based on the tags found in the inventory.
group_vars/role_ubuntu_server.yml: Contains ansible_user: ubuntu.
group_vars/role_redhat_server.yml: Contains ansible_user: ec2-user.
SSH Key: You defined your .pem file path in group_vars/all.yml or passed it via the command line.

Phase 4: Automation & Execution
Verification: You used the graph command to confirm hosts are in the right groups

ansible-inventory -i inventory.terraform_state.yml --graph

Unified Playbook: You wrote a playbook (site.yml) that uses ansible_os_family to:
Run apt for Ubuntu.
Run dnf/yum for Red Hat.
Deploy a custom index.html and start the web service

Phase 5: Running the Project
Execution: You run the entire setup with one command:

ansible-playbook -i inventory.terraform_state.yml site.yml
