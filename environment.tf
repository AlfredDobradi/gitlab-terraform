module "gitlab" {
    source = "./modules/core"

    ssh_user = var.ssh_user
    ssh_host = var.ssh_host
    ssh_port = var.ssh_port
    pvt_key = var.pvt_key
}

module "runner" {
    source = "./modules/runner"
    name = "badger"
    gitlab_runner_num = "${var.gitlab_token == "" || var.gitlab_url == "" ? 0 : var.gitlab_runner_num}"
    gitlab_token = var.gitlab_token
    gitlab_url = var.gitlab_url
}