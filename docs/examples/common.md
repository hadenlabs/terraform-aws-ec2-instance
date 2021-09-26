### common

```hcl
  module "main" {
    source  = "hadenlabs/ec2-instance/aws"
    version = "0.0.0"

    providers = {
      aws = aws
    }
  }
```
