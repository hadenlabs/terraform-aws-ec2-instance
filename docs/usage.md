# How to use this project

```hcl
  module "key" {
    source     = "hadenlabs/key-pair/aws"
    version    = ">=0.1"
    name       = "name-key"
    public_key = var.public_key
  }

  resource "aws_default_vpc" "default" {
    tags = var.tags
  }

  resource "aws_subnet" "this" {
    vpc_id                  = aws_default_vpc.default.id
    cidr_block              = "172.30.9.0/24"
    map_public_ip_on_launch = true
    tags                    = module.tags.tags
  }

  module "main" {
    depends_on = [
      module.key,
    ]

    source = "hadenlabs/ec2-instance/aws"
    version = "0.2.0"
    name           = "name-server"
    ami            = data.aws_ami.amazon_linux.id
    private_key    = var.private_key
    aws_key        = module.key.name
  }
```

Full working examples can be found in [examples](./examples) folder.
