resource "azurerm_resource_group" "res-0" {
  location = "koreacentral"
  name     = "wl"
}
resource "azurerm_linux_virtual_machine" "res-1" {
  admin_username        = "arfan"
  eviction_policy       = "Deallocate"
  location              = "koreacentral"
  max_bid_price         = 0.04
  name                  = "wl"
  network_interface_ids = [azurerm_network_interface.res-2.id]
  priority              = "Spot"
  resource_group_name   = azurerm_resource_group.res-0.name
  secure_boot_enabled   = true
  size                  = "Standard_D2as_v5"
  vtpm_enabled          = true
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
}
resource "azurerm_network_interface" "res-2" {
  accelerated_networking_enabled = true
  location                       = "koreacentral"
  name                           = "wl837"
  resource_group_name            = azurerm_resource_group.res-0.name
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-6.id
    subnet_id                     = azurerm_subnet.res-8.id
  }
}
resource "azurerm_network_interface_security_group_association" "res-3" {
  network_interface_id      = azurerm_network_interface.res-2.id
  network_security_group_id = azurerm_network_security_group.res-4.id
}
resource "azurerm_network_security_group" "res-4" {
  location            = "koreacentral"
  name                = "wl-nsg"
  resource_group_name = azurerm_resource_group.res-0.name
}
resource "azurerm_network_security_rule" "res-5" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "wl-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = azurerm_resource_group.res-0.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-4,
  ]
}
resource "azurerm_public_ip" "res-6" {
  allocation_method   = "Static"
  location            = "koreacentral"
  name                = "wl-ip"
  resource_group_name = azurerm_resource_group.res-0.name
}
resource "azurerm_virtual_network" "res-7" {
  address_space       = ["10.0.0.0/16"]
  location            = "koreacentral"
  name                = "wl-vnet"
  resource_group_name = azurerm_resource_group.res-0.name
}
resource "azurerm_subnet" "res-8" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = "wl-vnet"
  depends_on = [
    azurerm_virtual_network.res-7,
  ]
}
