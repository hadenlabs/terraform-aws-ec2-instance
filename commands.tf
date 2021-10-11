resource "null_resource" "provision_core" {
  triggers = {
    user        = var.ssh_user
    port        = var.ssh_port
    private_key = var.private_key
    host        = aws_instance.this.public_ip
  }

  depends_on = [aws_instance.this]

  connection {
    type        = "ssh"
    user        = self.triggers.user
    port        = self.triggers.port
    private_key = file(self.triggers.private_key)
    host        = self.triggers.host
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get install -y curl vim git libltdl7 python3 python3-pip python software-properties-common unattended-upgrades",
      "touch ~/provisioned", # Troll
    ]
  }
}

# installing docker through third-party
resource "null_resource" "provision_docker" {
  count      = local.outputs.enabled_docker ? 1 : 0
  depends_on = [null_resource.provision_core]

  triggers = {
    user        = var.ssh_user
    port        = var.ssh_port
    private_key = var.private_key
    host        = aws_instance.this.public_ip
  }

  connection {
    type        = "ssh"
    user        = self.triggers.user
    port        = self.triggers.port
    private_key = file(self.triggers.private_key)
    host        = self.triggers.host
  }

  provisioner "remote-exec" {
    inline = [
      format("%s %s", "rm -rf ", local.templates_path),
      format("%s %s", "mkdir -p ", local.templates_path),
    ]
  }

  provisioner "file" {
    destination = local.templates.docker.install.file
    content     = templatefile(local.templates.docker.install.template, local.templates.docker.install.vars)
  }

  provisioner "remote-exec" {
    inline = [
      format("%s %s", "sudo chmod a+x", local.templates.docker.install.file),
      format("%s %s", "sudo ", local.templates.docker.install.file),
    ]
  }
}