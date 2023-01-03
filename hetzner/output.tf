output "swarm-manager" {
  value = tomap({
    (hcloud_server.swarm-manager.name) = hcloud_server.swarm-manager.ipv4_address
  })
}

output "swarm-database" {
  value = tomap({
    (hcloud_server.swarm-database.name) = hcloud_server.swarm-database.ipv4_address
  })
}

output "swarm-workers" {
  value = zipmap(
    hcloud_server.swarm-worker.*.name, hcloud_server.swarm-worker.*.ipv4_address
  )
}

output "ssh-public-key" {
  value = data.hcloud_ssh_key.deploy.public_key
}
