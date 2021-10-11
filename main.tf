locals {
  templates_path = format("%s/%s", "/var/tmp/scripts", "ec2-instance")
  templates = {
    docker = {
      install = {
        template = format("%s/%s", path.module, "provision/scripts/docker/install.tpl.sh")
        file     = format("%s/%s", local.templates_path, "/docker_install.sh")
        vars     = {}
      }
    }
  }

  defaults = {
    rule_ingress = {
      type        = "ingress"
      from_port   = var.ssh_port
      to_port     = var.ssh_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  input = {
    rule_ingress   = length(var.rule_ingress) != 0 ? var.rule_ingress : [local.defaults.rule_ingress]
    enabled_docker = var.enabled_docker
    aws_key        = var.aws_key
  }

  generated = {
    rule_ingress = {
      for key, value in local.input.rule_ingress : key => merge(local.defaults.rule_ingress, value)
    }
    name           = var.name
    tags           = var.tags
    aws_key        = local.input.aws_key
    enabled_docker = local.input.enabled_docker
  }

  outputs = {
    rule_ingress   = local.generated.rule_ingress
    name           = local.generated.name
    tags           = local.generated.tags
    enabled_docker = local.generated.enabled_docker
    aws_key        = local.generated.aws_key
  }

}

resource "aws_security_group" "this" {
  name        = local.outputs.name
  description = "Allow traffic needed by instance"

  tags = local.outputs.tags

  lifecycle {
    create_before_destroy = true
  }
}

#AWS security group rule ingress
resource "aws_security_group_rule" "ingress" {
  depends_on = [
    aws_security_group.this,
  ]

  for_each          = local.outputs.rule_ingress
  description       = format("Ingress %s", local.outputs.name)
  security_group_id = aws_security_group.this.id
  type              = lookup(each.value, "type")
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  cidr_blocks       = lookup(each.value, "cidr_blocks")
}

#AWS security group rule egress
resource "aws_security_group_rule" "egress" {
  depends_on = [
    aws_security_group.this,
  ]

  for_each = {
    "instance" = aws_security_group.this.id,
  }

  description       = format("Egress %s: %s", local.outputs.name, each.key)
  security_group_id = each.value
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_88:This instance requires a public IP (direct SSH access)
  #checkov:skip=CKV_AWS_135:This instance is for test
  depends_on = [
    aws_security_group_rule.ingress,
    aws_security_group_rule.egress,
    aws_security_group.this,
  ]

  tags = local.outputs.tags

  lifecycle {
    ignore_changes = [
      tags,
      source_dest_check,
      ami,
      user_data,
      vpc_security_group_ids,
    ]
  }

  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = local.generated.aws_key
  source_dest_check = true

  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  monitoring = true

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    encrypted             = true
    volume_type           = "gp2"
    volume_size           = "16"
    delete_on_termination = true
    tags                  = local.outputs.tags
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}
