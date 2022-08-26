module "tags" {
  source    = "hadenlabs/tags/null"
  version   = ">=0.1"
  namespace = var.namespace

  stage = var.stage
  name  = var.name
  tags  = var.tags
}

#tfsec:ignore:AWS082
resource "aws_default_vpc" "default" {
  tags = var.tags
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.128.0/20"
  map_public_ip_on_launch = true
  tags                    = module.tags.tags
  depends_on = [
    module.tags,
  ]
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
  source         = "../.."
  name           = module.tags.name
  ami            = data.aws_ami.amazon_linux.id
  tags           = module.tags.tags
  private_key    = var.private_key
  enabled_docker = var.enabled_docker
  aws_key        = module.key.name
  vpc_id         = aws_default_vpc.default.id
  subnet_id      = aws_subnet.this.id
  depends_on = [
    module.tags,
    module.key,
  ]
}
