variable "bootstrap_port" {
  default     = "80"
  description = "TCP port bootstrap nginx is listening on. Used to build the bootstrap URL."
}

variable "bootstrap_private_ip" {
  description = "Private IP bootstrap nginx is listening on. Used to build the bootstrap URL."
}

variable "dcos_install_mode" {
  default     = "install"
  description = "Type of command to execute. Options: install or upgrade"
}

variable "dcos_skip_checks" {
  default     = false
  description = "Upgrade option: Used to skip all dcos checks that may block an upgrade if any DC/OS component is unhealthly. (optional) applicable: 1.10+"
}

variable "dcos_version" {
  default     = "1.11.3"
  description = "Specifies which DC/OS version instruction to use. Options: 1.13.1, 1.12.3, 1.11.10, etc. See dcos_download_path or dcos_version tree for a full list."
}

variable "num_public_agents" {
  description = "Specify the amount of public agents. These agents will host marathon-lb and edgelb"
}

variable "public_agent_ips" {
  type        = "list"
  description = "List of public agent IPs to SSH to"
}

variable "os_user" {
  default     = "centos"
  description = "The OS user to be used"
}

variable "trigger" {
  default     = []
  description = "Triggers for null resource"
}

variable "depends_on" {
  default     = []
  description = "Modules are missing the depends_on feature. Faking this feature with input and output variables"
}
