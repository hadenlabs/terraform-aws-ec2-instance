variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "ami" {
  type        = string
  description = "Id of ami of aws"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  default     = {}
}

variable "public_key" {
  type        = string
  description = "public key"
}

variable "private_key" {
  type        = string
  description = "private key"
}

variable "instance_type" {
  type        = string
  description = "type instance"
  default     = "t2.micro"
}

variable "ssh_user" {
  type        = string
  description = "user ssh"
  default     = "ubuntu"
}

variable "ssh_port" {
  type        = number
  description = "port ssh"
  default     = 22
}

variable "rule_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "list rule for security group"
  default     = []
}
