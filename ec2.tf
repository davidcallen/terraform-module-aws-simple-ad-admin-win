# ---------------------------------------------------------------------------------------------------------------------
# Deploy a EC2 Windows SimpleAD Admin for Desktop
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "simple-ad-admin" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.vpc_private_subnet_ids[var.aws_zone_placement_index]
  vpc_security_group_ids = [aws_security_group.simple-ad-admin.id]
  key_name               = var.aws_ssh_key_name
  # private_ip              = var.static_networking.ip_address

  user_data = templatefile("${path.module}/user-data-script.ps1", {
    host_name                   = local.name
    host_fqdn                   = var.hostname_fqdn
    host_name_short_ad_friendly = local.domain_host_name_short_ad_friendly
    domain_name                 = var.domain_name
    domain_netbios_name         = var.domain_netbios_name
    domain_join_user_name       = var.domain_join_user_name
    domain_join_user_password   = var.domain_join_user_password
    domain_login_allowed_groups = var.domain_login_allowed_groups[*]
    domain_login_allowed_users  = var.domain_login_allowed_users[*]
  })
  get_password_data = false
  root_block_device {
    delete_on_termination = true
    volume_size           = var.disk_root.size
    encrypted             = var.disk_root.encrypted
  }
  disable_api_termination = var.resource_deletion_protection
  tags = merge(var.tags, {
    Name                    = local.name
    HostNameShortADFriendly = local.domain_host_name_short_ad_friendly
    Zone            = var.aws_zones[var.aws_zone_placement_index]
    Visibility      = "private"
    Application     = var.name
    ApplicationName = var.name
  })
}
