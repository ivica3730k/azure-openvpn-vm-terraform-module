data "template_cloudinit_config" "virtual_machine_init" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/01-update-and-install-deps.sh", {})
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/02-setup-reverse-proxy-entries.sh", {
      reverse_proxy_entries = var.reverse_proxy_entries
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/03-install-letsencrypt-certificates.sh", {
      reverse_proxy_entries = var.reverse_proxy_entries
    })
  }



}