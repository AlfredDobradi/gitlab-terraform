variable "ssh_user" {
  type = string
}

variable "ssh_host" {
  type = string
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "pvt_key" {
    type = string
}

variable "gitlab_token" {
    type = string
    default = ""
}

variable "gitlab_url" {
    type = string
    default = ""
}

variable "gitlab_runner_num" {
    type = number
    default = 1
}