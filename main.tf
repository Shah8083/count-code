#################### RESOURCE GROUP ###########################
resource "azurerm_resource_group" "Sk-Rg" {
  name     = var.resource_group_name
  location = var.location
}
#################### VIRTUAL NETWORK ###########################
resource "azurerm_virtual_network" "Sk-Vnet" {
  name                = var.virtual_network
  resource_group_name = azurerm_resource_group.Sk-Rg.name
  location            = azurerm_resource_group.Sk-Rg.location
  address_space       = ["10.0.0.0/16"]
}
#################### SUBNET ###################################
resource "azurerm_subnet" "Sk-Subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Sk-Rg.name
  virtual_network_name = azurerm_virtual_network.Sk-Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
#################### NETWORK SECURITY GROUP ###################################
resource "azurerm_network_security_group" "Sk-nsg" {
  name                = "Skema-NSG"
  location            = azurerm_resource_group.Sk-Rg.location
  resource_group_name = azurerm_resource_group.Sk-Rg.name
}
#################### NETWORK INTERFACE WITH IP CONFIGURATION ###################################
resource "azurerm_network_interface" "Sk-NIC" {
  count               = var.NIC-count
  name                = "Skema-NIC-${count.index}"
  location            = azurerm_resource_group.Sk-Rg.location
  resource_group_name = azurerm_resource_group.Sk-Rg.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Sk-Subnet.id
    private_ip_address_allocation = "Dynamic"
  } 
}
#################### VIRTUAL MACHINE ############################################################
resource "azurerm_windows_virtual_machine" "Sk-VM" {
  count                 = var.VM-count
  name                  = var.azurerm_windows_vm[count.index]
  resource_group_name   = azurerm_resource_group.Sk-Rg.name
  location              = azurerm_resource_group.Sk-Rg.location
  size                  = "Standard_b2s"
  network_interface_ids = [azurerm_network_interface.Sk-NIC[count.index].id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
######################### ROUTE TABLE ###################################
resource "azurerm_route_table" "Sk-RT" {
  name                = "route-table"
  location            = azurerm_resource_group.Sk-Rg.location
  resource_group_name = var.resource_group_name
}
#################### SUBNET ROUTE TABLE ASSOCIATION ################################### 
resource "azurerm_subnet_route_table_association" "Sk-subRouteAsso" {
  subnet_id      = azurerm_subnet.Sk-Subnet.id
  route_table_id = azurerm_route_table.Sk-RT.id
}