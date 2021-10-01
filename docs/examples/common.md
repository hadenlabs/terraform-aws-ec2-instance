### common

```hcl
  module "main" {
    source  = "hadenlabs/ec2-instance/aws"
    version = "0.0.0"

    providers = {
      aws = aws
    }

    ami            = data.aws_ami.amazon_linux.id

    public_key     = var.public_key
    private_key    = var.private_key
  }
```

### with docker

```hcl

  module "tags" {
    source      = "hadenlabs/tags/null"
    version     = "0.1.1"
    namespace   = var.namespace
    environment = var.environment
    stage       = var.stage
    name        = var.name
    tags        = var.tags
  }

  module "main" {
    source  = "hadenlabs/ec2-instance/aws"
    version = "0.0.0"
    providers = {
      aws = aws
    }

    name           = module.tags.name
    ami            = data.aws_ami.amazon_linux.id
    tags           = module.tags.tags
    enabled_docker = var.enabled_docker
    public_key     = var.public_key
    private_key    = var.private_key
  }
```
