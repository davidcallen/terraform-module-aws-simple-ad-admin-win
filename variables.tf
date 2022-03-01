variable "aws_region" {
  description = "AWS region to apply terraform to."
  default     = "eu-west-1"
  type        = string
}
variable "aws_zones" {
  description = "AWS zones to apply terraform to. The first zone in the list will be the default for single AZ requirements."
  default     = ["eu-west-1a", "eu-west-1b"]
  type        = list(string)
}
variable "aws_zone_placement_index" {
  type        = number
  description = "The index for the aws_zones list variable to deploy within"
  default     = 0
}
variable "org_short_name" {
  description = "Short name for organisation"
  default     = ""
  type        = string
}
variable "org_domain_name" {
  description = "Domain name for organisation"
  default     = ""
  type        = string
}
variable "name" {
  description = "The Name of the server that will be deployed"
  default     = "simple-ad-admin"
  type        = string
}
variable "name_suffix" {
  description = "The AWS name suffix for AWS resources"
  type        = string
  default     = ""
}
variable "resource_name_prefix" {
  description = "The Name prefix to be applied to all resources created by this module"
  default     = ""
  type        = string
}
variable "resource_deletion_protection" {
  description = "For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources"
  default     = true
  type        = bool
}
variable "hostname_fqdn" {
  description = "FQDN Name of the server that will be deployed"
  default     = ""
  type        = string
}
variable "route53_enabled" {
  description = "If using Route53 for DNS resolution"
  default     = false
  type        = bool
}
variable "route53_direct_dns_update_enabled" {
  description = "If using direct add/update of DNS record to Route53"
  default     = false
  type        = bool
}
variable "route53_private_hosted_zone_id" {
  description = "Route53 Private Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}
variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type        = string
  default     = ""
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "aws_instance_type" {
  type = string
  # e.g. m5.micro
  default = ""
}
variable "aws_ami_id" {
  type    = string
  default = ""
}
variable "aws_ssh_key_name" {
  type    = string
  default = ""
}
variable "app_ssh_public_key" {
  type    = string
  default = ""
}
variable "iam_instance_profile" {
  type    = string
  default = ""
}
variable "iam_instance_role_arn" {
  type    = string
  default = ""
}
variable "disk_root" {
  description = "Disk storage for root"
  type = object({
    encrypted = bool
    size      = number
  })
  default = {
    encrypted = true
    size      = 30
  }
}
variable "disk_simple_ad_admin_home" {
  description = "Disk storage options for SimpleAD Admin Home Dir. Will be mounted at /mnt/simple-ad-admin and symlinked to /var/simple-ad-admin"
  type = object({
    enabled = bool
    type    = string
    # EBS or EFS
    encrypted = bool
    size      = number
    # In Gigabytes
  })
  default = {
    enabled   = true
    type      = "EBS"
    encrypted = true
    size      = "20"
  }
}
variable "allowed_ingress_cidrs" {
  type = object({
    ssh = list(string)
    rdp = list(string)
  })
}
variable "allowed_egress_cidrs" {
  type = object({
    http              = list(string)
    https             = list(string)
    telegraf_influxdb = list(string)
  })
}
variable "cloudwatch_alarm_default_sns_topic_arn" {
  type    = string
  default = ""
}
variable "cloudwatch_enabled" {
  type    = bool
  default = true
}
variable "cloudwatch_refresh_interval_secs" {
  type    = number
  default = 60
}
variable "telegraf_enabled" {
  type    = bool
  default = true
}
variable "telegraf_influxdb_url" {
  type    = string
  default = ""
}
variable "telegraf_influxdb_password_secret_id" {
  type      = string
  default   = ""
  sensitive = true
}
variable "telegraf_influxdb_retention_policy" {
  type    = string
  default = "autogen"
}
variable "telegraf_influxdb_https_insecure_skip_verify" {
  type    = bool
  default = false
}
//variable "nexus_linux_user_name" {
//  description = "Linux user for running Nexus process under."
//  type        = string
//  default     = "nexus"
//}
//variable "nexus_linux_user_group" {
//  description = "Linux user group for running Nexus process under."
//  type        = string
//  default     = "nexus"
//}
//variable "nexus_user_ssh_public_key" {
//  description = "SSH Public Key for ssh login as Nexus user"
//  type        = string
//  default     = ""
//}
//variable "nexus_config_file_pathnames" {
//  description = "Config file path and names to be loaded by Nexus configuration-as-code plugin on 1st launch."
//  type        = list(string)
//  default     = []
//}
//variable "nexus_config_files" {
//  description = "Config file names and base64-encoded contents to be loaded by Nexus configuration-as-code plugin on 1st launch."
//  type = list(object({
//    filename          = string
//    contents_base64   = string
//    contents_md5_hash = string
//  }))
//  default = []
//}
variable "domain_name" {
  type        = string
  description = "DNS Domain name"
  default     = ""
}
variable "domain_netbios_name" {
  type        = string
  description = "NetBIOS Domain name (aka Legacy Domain Name). Limited to 15 chars and in UPPERCASE."
  default     = ""
}
variable "domain_join_user_name" {
  type        = string
  description = ""
  default     = ""
}
variable "domain_join_user_password" {
  type        = string
  description = ""
  default     = ""
}
variable "domain_login_allowed_users" {
  type        = list(string)
  description = "Active Directory User Names that allowed to RDP login to computer"
  default     = []
}
variable "domain_login_allowed_groups" {
  type        = list(string)
  description = "Active Directory Groups that allowed to RDP login to computer"
  default     = []
}
variable "tags" {
  description   = "Tags"
  type          = map(string)
  default       = {}
}


//variable "aws_region" {
//  description = "AWS region to apply terraform to."
//  default     = "eu-west-1"
//  type        = string
//}
//variable "aws_zones" {
//  description = "AWS zones to apply terraform to. The first zone in the list will be the default for single AZ requirements."
//  default     = ["eu-west-1a", "eu-west-1b"]
//  type        = list(string)
//}
//variable "org_short_name" {
//  description = "Short name for organisation e.g. prpl"
//  default     = "prpl"
//  type        = string
//}
//variable "environment" {
//  description = "Environment information e.g. account IDs, public/private subnet cidrs"
//  type = object({
//    name                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
//    account_id                   = string # These cidrs are needed to setup SecurityGroup rules, and routes for cross-account access.
//    cidr_block                   = string
//    private_subnets_cidr_blocks  = list(string)
//    public_subnets_cidr_blocks   = list(string)
//    resource_name_prefix         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
//    resource_deletion_protection = bool
//    default_tags                 = map(string)
//  })
//  default = {
//    name                         = ""
//    account_id                   = ""
//    cidr_block                   = ""
//    private_subnets_cidr_blocks  = []
//    public_subnets_cidr_blocks   = []
//    resource_name_prefix         = ""
//    resource_deletion_protection = true
//    default_tags                 = {}
//  }
//}
//variable "vpc" {
//  description = "VPC information. These are inputs to the VPC module github.com/terraform-aws-modules/terraform-aws-vpc.git"
//  type = object({
//    vpc_id                      = string # VPC cidr block. Must not overlap with other VPCs in this aws account or others within our organisation.
//    cidr_block                  = string # List of VPC private subnet cidr blocks. Must not overlap with other VPCs in this aws account or others within our organisation.
//    private_subnets_cidr_blocks = list(string)
//    private_subnets_ids         = list(string) # List of VPC public subnet cidr blocks. Must not overlap with other VPCs in this aws account or others within our organisation.
//    public_subnets_cidr_blocks  = list(string)
//    public_subnets_ids          = list(string)
//  })
//  default = {
//    vpc_id                      = ""
//    cidr_block                  = "",
//    private_subnets_cidr_blocks = [],
//    private_subnets_ids         = []
//    public_subnets_cidr_blocks  = []
//    public_subnets_ids          = []
//  }
//}
//variable "name" {
//  type    = string
//  default = ""
//}
//variable "aws_zone_placement_index" {
//  type        = number
//  description = "The index for the aws_zones list variable to deploy within"
//  default     = 0
//}
///*
//variable "static_networking" {
//  type        = object({
//    ip_address        = string
//    netmask           = string
//    gateway           = string
//  })
//  description = "Force static network IP address (instead of DHCP via DHCP Option Set)"
//  default     = {
//    ip_address        = ""
//    netmask           = ""
//    gateway           = ""
//  }
//}
//*/
//variable "domain_name" {
//  type        = string
//  description = "DNS Domain name"
//  default     = ""
//}
//variable "netbios_name" {
//  type        = string
//  description = "NetBIOS Domain name (aka Legacy Domain Name). Limited to 15 chars and in UPPERCASE."
//  default     = ""
//}
//variable "dns_ip_addresses" {
//  type        = list(string)
//  description = "Force specific DNS servers (instead of via DHCP Option Set)"
//  default     = []
//}
//variable "users" {
//  type = list(object({
//    user_name         = string
//    aws_instance_name = string
//    aws_ami_id        = string
//    aws_instance_type = string # e.g. m5.micro
//    data_volume_size  = number
//    static_networking = object({
//      ip_address = string
//      netmask    = string
//      gateway    = string
//    })
//  }))
//  description = ""
//  default     = []
//}
//variable "domain_join_user_name" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "domain_join_user_password" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "login_allowed_domain_groups" {
//  type        = list(string)
//  description = "Active Directory Groups that allowed to RDP login to computer"
//  default     = []
//}
//variable "aws_ami_id" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "aws_instance_type" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "aws_ssh_key_name" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "iam_instance_profile" {
//  type        = string
//  description = ""
//  default     = ""
//}
//variable "storage_encrypted" {
//  type        = bool
//  description = "Encrypt EBS root and data volumes with default AWS Managed KMS key."
//  default     = true
//}
//variable "allowed_ingress_cidrs" {
//  type = object({
//    rdp = list(string)
//    ssh = list(string)
//  })
//  default = {
//    rdp = []
//    ssh = []
//  }
//}
//variable "global_default_tags" {
//  description = "Global default tags"
//  default     = {}
//  type        = map(string)
//}