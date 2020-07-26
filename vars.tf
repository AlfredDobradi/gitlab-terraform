variable "ssh_user" {
    type = string
}

variable "ssh_host" {
    type = string
}

variable "ssh_port" {
    type = number
    default = 22
}

variable "pvt_key" {
    type = string
}