/**
 * DC/OS public agent remote exec install
 * ============
 * This module install DC/OS on public agents with remote exec via SSH
 *
 * EXAMPLE
 * -------
 *
 *```hcl
 * module "dcos-public-agents-install" {
 *   source  = "terraform-dcos/dcos-install-public-agents-remote-exec/null"
 *   version = "~> 0.1"
 *
 *   bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
 *   bootstrap_port       = "80"
 *   os_user              = "${module.dcos-infrastructure.public_agents.os_user}"
 *   dcos_install_mode    = "install"
 *   dcos_version         = "${var.dcos_version}"
 *   public_agent_ips     = ["${module.dcos-infrastructure.public_agents.public_ips}"]
 *   num_public_agents    = "1"
 * }
 *```
 */

module "dcos-mesos-public-agent" {
  source  = "dcos-terraform/dcos-core/template"
  version = "~> 0.0"

  # source               = "/Users/julferts/git/github.com/fatz/tf_dcos_core"
  bootstrap_private_ip = "${var.bootstrap_private_ip}"
  dcos_bootstrap_port  = "${var.bootstrap_port}"

  # Only allow upgrade and install as installation mode
  dcos_install_mode = "${var.dcos_install_mode}"
  dcos_version      = "${var.dcos_version}"
  role              = "dcos-mesos-agent-public"
}

resource "null_resource" "public-agents" {
  count = "${var.num_public_agents}"

  triggers = {
    dependency_id = "${join(",", var.depends_on)}"
  }

  connection {
    host = "${element(var.public_agent_ips, count.index)}"
    user = "${var.os_user}"
  }

  provisioner "remote-exec" {
    inline = [
      "until test -f /opt/dcos-prereqs.installed; do echo waiting for init install to finish;sleep 30;done",
    ]
  }

  provisioner "file" {
    content     = "${module.dcos-mesos-public-agent.script}"
    destination = "run.sh"
  }

  # Wait for bootstrapnode to be ready
  provisioner "remote-exec" {
    inline = [
      "until $(curl --output /dev/null --silent --head --fail http://${var.bootstrap_private_ip}:${var.bootstrap_port}/dcos_install.sh); do printf 'waiting for bootstrap node to serve...'; sleep 20; done",
    ]
  }

  # Install Master Script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x run.sh",
      "sudo ./run.sh",
    ]
  }

  depends_on = ["module.dcos-mesos-public-agent"]
}
