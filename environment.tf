module "gitlab" {
    source = "./modules/core"

    ssh_user = var.ssh_user
    ssh_host = var.ssh_host
    ssh_port = var.ssh_port
    pvt_key = var.pvt_key
}