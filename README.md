# terraform-learning

# a simple project to explore terraform code specific to Azure 


This project utilizes a number of modules to deploy a set of virtual machines based on user input.

This terraform bundle will perform the following:

* deploy a resource group 
* deploy and configure a vnet
* deploy N number of VM nodes of a specified size and with a specified OS mapped to them
* deploy 3 managed disks and attach them to each VM
* Configure a default admin user utilizing specified keys

In oder to mount the disks, we can create an ansible playbook to perform that action. 
