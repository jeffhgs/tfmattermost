variable "db_password" {}
variable "db_host" {}

resource "template_file" "docker-compose" {
  template = "${file("${path.module}/../script/docker-compose.yml.tpl")}"
  vars = {
    db_password = "${var.db_password}"
    db_host = "${var.db_host}"
  }
}

resource "template_file" "installmm" {
  template = "${file("${path.module}/../script/installmm.sh")}"
  vars = {
  }
}

resource "template_file" "run" {
  template = "${file("${path.module}/../script/run.sh")}"
  vars = {
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "installmm.sh"
    content_type = "text/x-shellscript"
    content      = "${template_file.installmm.rendered}"
  }

  # Main cloud-config configuration file.
  part {
    filename     = "run.sh"
    content_type = "text/x-shellscript"
    content      = "${template_file.run.rendered}"
  }

  # Main cloud-config configuration file.
  part {
    filename     = "docker-compose.yml"
    content_type = "text/x-yaml"
    content      = "${template_file.docker-compose.rendered}"
  }
  part {
    content = "#cloud-config\n---\nruncmd:\n - bash ./installmm.sh"
  }
}

output "docker-compose1" {
  value = "${template_file.docker-compose.rendered}"
}

output "cloudinit-config1" {
  value = "${data.template_cloudinit_config.config.rendered}"
}

