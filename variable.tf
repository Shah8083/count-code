variable "resource_group_name" {

  description = "Resource Group Name"

  default = "SkemaRG1"

}

variable "NIC-count" {

  description = "Number of NIC's to create"

  default     = 2

}

variable "virtual_network" {

description = "Name Of Virtual Network" 

default = "Skema-VNET"

}
 
variable "azurerm_windows_vm" {

  type = list(string)

  description = "Name of the VM"

  default     = ["Skema-vm-1" ,"Skema-vm-2"]

}
 
variable "location" {

  description = "Azure region for the resources"

  default     = "West Europe"

}
 
variable "vm_size" {

  description = "Size of the VM"

  default     = "Standard_F2"

}
 
variable "admin_username" {

  description = "Username for the VM"

  default     = "adminuser"

}
 
variable "admin_password" {

  description = "Password for the VM"

  default     = "P@$$w0rd1234!"

}

variable "VM-count" {

  description = "Number of VMs to create"

  default = "2"

}