# ---------------------------------------------------------------------------------------------------------------------
# Security Group for a EC2 Windows SimpleAD AdminDesktop
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "simple-ad-admin" {
  name        = local.name
  description = "simple-ad-admin"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, {
    Name            = local.name
    Application     = "Windows Desktop"
    ApplicationName = var.name
  })
}

# All ingress to port 3389 (RDP)
resource "aws_security_group_rule" "simple-ad-admin-allow-ingress-rdp" {
  type            = "ingress"
  description     = "rdp"
  from_port       = 3389
  to_port         = 3389
  protocol        = "tcp"
  cidr_blocks     = var.allowed_ingress_cidrs.rdp
  security_group_id = aws_security_group.simple-ad-admin.id
}
# All ingress to port 22 (SSH)
resource "aws_security_group_rule" "simple-ad-admin-allow-ingress-ssh" {
  type            = "ingress"
  description     = "ssh"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = var.allowed_ingress_cidrs.ssh
  security_group_id = aws_security_group.simple-ad-admin.id
}

# Allow egress to all ip addresses
resource "aws_security_group_rule" "simple-ad-admin-allow-egress-all" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = -1
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.simple-ad-admin.id
}

