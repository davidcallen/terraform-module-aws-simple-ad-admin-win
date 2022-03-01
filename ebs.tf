/* The "aws_volume_attachment" method attaches the disk after first bootup and therefore the
 * Amazon EC2Launch InitializeInstance.ps1 will not find it and therefore it will be uninitialized.
 * Solutions:
 * 1) A 2nd bootup will find it and initialise the disk and attach it as D: drive
 * 2) or manually run script C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 (probably as Administrator)
 * 3) add another schedule to run C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 for Startup + 2 mins
 */
resource "aws_ebs_volume" "simple-ad-admin-data" {
  count             = (var.disk_simple_ad_admin_home.enabled) ? 1 : 0
  availability_zone = var.aws_zones[var.aws_zone_placement_index]
  size              = var.disk_simple_ad_admin_home.size
  encrypted         = var.disk_simple_ad_admin_home.encrypted

  tags = merge(var.tags, {
    Name = local.name
    # Name            = (var.aws_instance_name == "") ? "${var.resource_name_prefix}-${var.name}-${replace(var.user_name, ".", "-")}" : var.aws_instance_name
    HostNameShortADFriendly = local.domain_host_name_short_ad_friendly
    Type                    = "Data"
    Zone                    = var.aws_zones[var.aws_zone_placement_index]
    Visibility              = "private"
    Application             = var.name
    ApplicationName         = var.name
  })
}

resource "aws_volume_attachment" "simple-ad-admin-data" {
  count       = (var.disk_simple_ad_admin_home.enabled) ? 1 : 0
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.simple-ad-admin-data[0].id
  instance_id = aws_instance.simple-ad-admin.id
}
