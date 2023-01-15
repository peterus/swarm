provider "hcloud" {
  token = var.HCLOUD_TOKEN
}

provider "hetznerdns" {
  apitoken = var.HCLOUD_DNS_TOKEN
}

resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "192.168.0.0/24"
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "192.168.0.0/24"
}

resource "hcloud_server" "swarm-manager" {
  name        = "swarm-manager"
  image       = var.os-image
  server_type = var.swarm-manager-type
  datacenter  = data.hcloud_datacenter.nuremberg.name
  ssh_keys    = [data.hcloud_ssh_key.deploy.id]

  network {
    network_id = hcloud_network.network.id
    ip         = "192.168.0.2"
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
    ip         = "192.168.0.1${count.index}"
  }

  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

resource "hetznerdns_zone" "zone1" {
  name = "aprs-map.info"
  ttl = 60
  lifecycle {
    prevent_destroy = true
  }
}

resource "hetznerdns_record" "test" {
  zone_id = hetznerdns_zone.zone1.id
  name = "test"
  value = hcloud_server.swarm-manager.ipv4_address
  type = "A"
  ttl= 60
  lifecycle {
    prevent_destroy = true
  }
}

resource "hetznerdns_record" "alias_test" {
  zone_id = hetznerdns_zone.zone1.id
  name = "*.test"
  value = hcloud_server.swarm-manager.ipv4_address
  type = "A"
  ttl= 60
  lifecycle {
    prevent_destroy = true
  }
}
