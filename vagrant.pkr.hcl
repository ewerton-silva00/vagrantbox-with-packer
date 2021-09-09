// Declare Variables
variable "vagrant_source_path" {
  description = "URL of the vagrant box to use, or the name of the vagrant box."
  type = string
  default = "" // e.g. ewerton_silva00/centos-7-x86_64-minimal-2003
}

variable "vagrant_output_dir" {
  description = "The directory to create that will contain your output box."
  type = string
  default = "" // e.g. /tmp/packer
}

variable "vagrant_box_name" {
  description = "Name assigned to Vagrant Box"
  type = string
  default = "" // e.g. centos-7-x86_64-minimal-2009

  validation {
    condition = can(regex("^[\\w-]+$", var.vagrant_box_name))
    error_message = "The image name contains invalid characters."
  }
}

variable "vagrant_box_version" {
  description = "What box version to use when initializing Vagrant."
  type = string
  default = "" // e.g. 20210906.0

  validation {
    condition = can(regex("^[\\d{8}\\.\\d{1}]+$", var.vagrant_box_version))
    error_message = "The version informed is incorrect."
  }
}

variable "vagrant_cloud_token" {
  description = "Your access token for the Vagrant Cloud API. Inform as environment variable."
  type = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "vagrant_cloud_box_tag" {
  description = "The shorthand tag for your box that maps to Vagrant Cloud"
  type = string
  default = "" // e.g. ewerton_silva00/centos-7-x86_64-minimal-2009
}

variable "vagrant_cloud_version_description" {
  description = "Optional Markdown text used as a full-length and in-depth description of the version, typically for denoting changes introduced."
  type = string
  default = ""
}

variable "vagrant_cloud_keep_input_artifact" {
  description = "When true, preserve the local box after uploading to Vagrant cloud. Defaults to 'true'."
  type = bool
  default = true
}

// Builder 'Vagrant' settings
source "vagrant" "box" {
  communicator = "ssh"
  source_path = var.vagrant_source_path
  output_dir = var.vagrant_output_dir
  box_name = var.vagrant_box_name
  box_version = var.vagrant_box_version
  provider = "virtualbox"
  add_force = true
  teardown_method = "destroy" // e.g. halt, suspend or destroy
}

build {
  sources = [
    "source.vagrant.box"
  ]
  // Execute commands on Vagrant Box
  provisioner "shell" {
    inline = [
      "sudo yum clean all && sudo yum update -y"
    ]
  }

  post-processors {
    post-processor "artifice" {
      files = [
        "${var.vagrant_output_dir}/{{.Provider}}.box"
      ]
    }
    post-processor "vagrant-cloud" {
      vagrant_cloud_url = "https://vagrantcloud.com/api/v1"
      access_token = var.vagrant_cloud_token
      box_tag = var.vagrant_cloud_box_tag
      version = var.vagrant_box_version
      version_description = var.vagrant_cloud_version_description
      keep_input_artifact = var.vagrant_cloud_keep_input_artifact
    }
  }
}
