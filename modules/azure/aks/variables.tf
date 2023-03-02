# General configuration
variable "resource_group" {
    type = string
}

variable "location" {
    type = string
}

variable "env" {
    type = string
    #stg01
}

variable "subnet_id" {
    type = string
}

variable "private_cluster_enabled" {
    type = bool
    default = true
}

variable "network_plugin" {
    type = string
    default = "kubenet"
}

# Master NodePool Variables
variable "master_node_type" {
    type = string
    default = "Standard_DS1_v2"
}

variable "master_pool_min_nodes" {
    type = number
    default = 1
}

variable "master_pool_max_nodes" {
    type = number
    default = 1
}

variable "master_os_disk_size" {
    type = number
    default = 50
}

# Worker Pool Configuration
variable "worker_node_type" {
    type = string
    default = "Standard_DS1_v2"
}

variable "worker_pool_min_nodes" {
    type = number
    default = 1
}

variable "worker_pool_max_nodes" {
    type = number
    default = 1
}

variable "worker_os_disk_size" {
    type = number
    default = 50
}


variable "tags" {
    type = map
}


variable "install_cert_manager" {
    type = bool
    default = false
}

