provider "hcloud" {
  token = var.HCLOUD_TOKEN
}

resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_server" "swarm-manager" {
  name        = "swarm-manager"
  image       = var.os-image
  server_type = var.swarm-manager-type
  datacenter  = data.hcloud_datacenter.nuremberg.name
  ssh_keys    = [data.hcloud_ssh_key.deploy.id]

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.2"
  }

  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

resource "hcloud_server" "swarm-database" {
  name        = "swarm-database"
  image       = var.os-image
  server_type = var.database-type
  datacenter  = data.hcloud_datacenter.nuremberg.name
  ssh_keys    = [data.hcloud_ssh_key.deploy.id]

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.3"
  }

  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

resource "hcloud_server" "swarm-worker" {
  name        = "swarm-worker-${count.index}"
  image       = var.os-image
  server_type = var.swarm-worker-type
  datacenter  = data.hcloud_datacenter.nuremberg.name
  ssh_keys    = [data.hcloud_ssh_key.deploy.id]
  count       = var.count-swarm-workers

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.1${count.index}"
  }

  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}
