variable "HCLOUD_TOKEN" {
  sensitive = true
}

variable "os-image" {
  default = "ubuntu-22.04"
}

variable "swarm-manager-type" {
  default = "cx21"
}

variable "swarm-worker-type" {
  default = "cx21"
}

variable "count-swarm-workers" {
  default = 3
}

variable "database-type" {
  default = "cx21"
}

data "hcloud_datacenter" "nuremberg" {
  name = "nbg1-dc3"
}

data "hcloud_ssh_key" "deploy" {
  name = "deploy"
}
