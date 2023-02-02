data "template_cloudinit_config" "openvpn_virtual_machine_init" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/01-update-and-install-deps.sh", {})
  }
  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/02-install-openvpn-server.sh", {})
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/03-create-ovpn-users.sh", {
      storage_container_name              = "xxx" # TODO
      storage_container_connection_string = "xxx" # TODO
    })
  }

}