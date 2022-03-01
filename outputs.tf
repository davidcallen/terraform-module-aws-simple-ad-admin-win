# TODO : Get the decryption of the Admin password to work so can output for convenience - doesnt seem to work
output "administrator_password" {
  value = "not-working" # rsadecrypt(aws_instance.simple-ad-admin.password_data, file(var.win_desktop.ssh_private_key_filename))
}
output "aws_instance_private_ip" {
  value = aws_instance.simple-ad-admin.private_ip
}
