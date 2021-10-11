<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=0.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >=0.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.provision_core](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.provision_docker](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | Id of ami of aws | `string` | n/a | yes |
| <a name="input_aws_key"></a> [aws\_key](#input\_aws\_key) | aws key pair name | `string` | n/a | yes |
| <a name="input_enabled_docker"></a> [enabled\_docker](#input\_enabled\_docker) | enabled install docker | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | type instance | `string` | `"t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | private key | `string` | n/a | yes |
| <a name="input_rule_ingress"></a> [rule\_ingress](#input\_rule\_ingress) | list rule for security group | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | port ssh | `number` | `22` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | user ssh | `string` | `"ubuntu"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | instance instance. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | private ip. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | public ip. |
<!-- END_TF_DOCS -->