# General configuration
variable "resource_group" {
  type    = string
  default = "stage"
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "env" {
  type = string
  #stg01
}

variable "vnet_name" {
  type    = string
  default = "stage-vnet"
}
variable "subnet_name" {
  type = string
}


# Master NodePool Variables
variable "master_node_type" {
  type    = string
  default = "Standard_B1s"
}

variable "master_pool_min_nodes" {
  type    = number
  default = 1
}

variable "master_pool_max_nodes" {
  type    = number
  default = 2
}

variable "master_os_disk_size" {
  type    = number
  default = 30
}

# Worker Pool Configuration
variable "worker_node_type" {
  type    = string
  default = "Standard_B1s"
}

variable "worker_pool_min_nodes" {
  type    = number
  default = 1
}

variable "worker_pool_max_nodes" {
  type    = number
  default = 2
}

variable "worker_os_disk_size" {
  type    = number
  default = 30
}
