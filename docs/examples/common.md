<!-- Space: Projects -->
<!-- Parent: TerraformAwsEc2Instance -->
<!-- Title: Examples TerraformAwsEc2Instance -->
<!-- Label: Examples -->
<!-- Include: ./../disclaimer.md -->
<!-- Include: ac:toc -->

### common

```hcl
  module "tags" {
    source      = "hadenlabs/tags/null"
    version     = ">=0.1"
    namespace   = var.namespace
    stage       = var.stage
    name        = var.name
    tags        = var.tags
  }

  module "key" {
    source     = "hadenlabs/key-pair/aws"
    version    = ">=0.1"
    name       = module.tags.name
    tags       = module.tags.tags
    public_key = var.public_key
    depends_on = [
      module.tags,
    ]
  }

  module "main" {
    source  = "hadenlabs/ec2-instance/aws"
    version = "0.2.0"
    name           = module.tags.name
    ami            = data.aws_ami.amazon_linux.id
    tags           = module.tags.tags
    private_key    = var.private_key
    aws_key        = module.key.name
    depends_on = [
      module.tags,
      module.key,
    ]
  }
```

### with docker

```hcl

  module "tags" {
    source      = "hadenlabs/tags/null"
    version     = ">=0.1"
    namespace   = var.namespace
    stage       = var.stage
    name        = var.name
    tags        = var.tags
  }

  module "key" {
    source     = "hadenlabs/key-pair/aws"
    version    = ">=0.1"
    name       = module.tags.name
    tags       = module.tags.tags
    public_key = var.public_key
    depends_on = [
      module.tags,
    ]
  }

  module "main" {
    source  = "hadenlabs/ec2-instance/aws"
    version = "0.2.0"
    providers = {
      aws = aws
    }

    name           = module.tags.name
    ami            = data.aws_ami.amazon_linux.id
    tags           = module.tags.tags
    enabled_docker = var.enabled_docker
    private_key    = var.private_key
    depends_on = [
      module.tags,
      module.key,
    ]
  }
```
