resource "null_resource" "cluster" {
  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "echo Environment Selected: ${var.env} - Region Selected: ${var.region}"
  }
}