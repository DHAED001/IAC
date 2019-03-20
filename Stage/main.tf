provider "azurerm" {
    version = "1.22.0"
    subscription_id = "${var.subscriptionid}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscriptionid" {}
variable "web_server_location" {}
variable "web_server_rg" {}
variable "resource_prefix" {}
variable "web_server_address_space" {}
variable "web_server_name" {}
variable "environment" {}
variable "web_server_count" {}
variable "web_server_subnets" {
  type = "list"
}
variable "terraform_script_version" {}
variable "domain_name_label" {}



locals {
  web_server_name   = "${var.environment == "production" ? "${var.web_server_name}-prd" : "${var.web_server_name}-dev"}"
  build_environment = "${var.environment == "production" ? "production" : "development"}"
}

resource "azurerm_resource_group" "App_server_rg" {
  name     = "${var.web_server_rg}"
  location = "${var.web_server_location}"

tags {
  environment   = "${local.build_environment}"
  build-version = "${var.terraform_script_version}"
  }
}
resource "azurerm_virtual_network" "web_server_vnet" {
  name                        = "${var.resource_prefix}-vnet"
  location                    = "${var.web_server_location}"
  resource_group_name         = "${azurerm_resource_group.web_server_rg.name}"
  address_space               = ["${var.web_server_address_space}"]

}