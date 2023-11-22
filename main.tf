# Load the Ansible configuration template
data "template_file" "ansible_config" {
  template = file("ansible.cfg.tpl")

  vars = {
    mastert_ips = join("\n", aws_instance.mastert.*.private_ip)
    workert_ips = join("\n", aws_instance.workert.*.private_ip)
  }
}

# Load the Ansible inventory template
data "template_file" "ansible_inventory" {
  template = file("ansible_inventory.tpl")

  vars = {
    mastert_ips = join("\n", aws_instance.mastert.*.private_ip)
    workert_ips = join("\n", aws_instance.workert.*.private_ip)
  }
}

# Generate a random private key for SSH
resource "tls_private_key" "ansible_private_key1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Output the generated Ansible configuration, inventory, and private key content
output "ansible_config_content" {
  value = data.template_file.ansible_config.rendered
}

output "ansible_inventory_content" {
  value = data.template_file.ansible_inventory.rendered
}

output "private_key" {
  value = tls_private_key.ansible_private_key1.private_key_pem
  sensitive = true
}
