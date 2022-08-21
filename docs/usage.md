# How to use this project

```hcl
  module "key" {
    source     = "hadenlabs/key-pair/aws"
    version    = ">=0.1"
    name       = "name-key"
    public_key = var.public_key
  }

  module "main" {
    source = "hadenlabs/ec2-instance/aws"
    version = "0.2.0"
    name           = "name-server"
    ami            = data.aws_ami.amazon_linux.id
    private_key    = var.private_key
    aws_key        = module.key.name
    depends_on = [
      module.key,
    ]
  }
```

Full working examples can be found in [examples](./examples) folder.
