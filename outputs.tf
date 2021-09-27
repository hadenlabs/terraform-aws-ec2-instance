output "instance" {
  description = "instance instance."
  value       = aws_instance.this
}

output "public_ip" {
  description = "public ip."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "private ip."
  value       = aws_instance.this.private_ip
}

output "aws_key_pair" {
  description = "key_pair of instance."
  value       = aws_key_pair.this
}
