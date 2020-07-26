resource "docker_image" "gitlab" {
    name = data.docker_registry_image.gitlab.name
    pull_triggers = [data.docker_registry_image.gitlab.sha256_digest]
}

resource "docker_container" "gitlab" {
    name = "gitlab"
    image = docker_image.gitlab.latest
    restart = "on-failure"
    must_run = true

    hostname = "work.0xa1.link"
    env = [
        "GITLAB_OMNIBUS_CONFIG=gitlab_rails['gitlab_shell_ssh_port'] = 2233;"
    ]

    healthcheck {
        interval     = "1m0s"
        retries      = 5
        start_period = "0s"
        test         = [
            "CMD-SHELL",
            "/opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10",
        ]
        timeout      = "30s"
    }

    ports {
        internal = 22
        external = 2233
    }

    volumes {
        volume_name = "gitlab_config"
        container_path = "/etc/gitlab"
        read_only = false
    }

    volumes {
        volume_name = "gitlab_logs"
        container_path = "/var/log/gitlab"
        read_only = false
    }

    volumes {
        volume_name = "gitlab_data"
        container_path = "/var/opt/gitlab"
        read_only = false
    }
}

resource "docker_volume" "gitlab_data" {
    name = "gitlab_data"
}

resource "docker_volume" "gitlab_config" {
    name = "gitlab_config"
}

resource "docker_volume" "gitlab_logs" {
    name = "gitlab_logs"
}

resource "null_resource" "nginx" {
    provisioner "file" {
        source = "${path.module}/files/prepare.sh"
        destination = "/tmp/prepare.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/prepare.sh",
            "/tmp/prepare.sh 0xa1.link work"
        ]
    }

    provisioner "file" {
        content = templatefile("${path.module}/files/nginx.conf.tpl", {
            gitlab_ip = docker_container.gitlab.ip_address,
            domain = "0xa1.link",
            subdomain = "work"
        })
        destination = "/etc/nginx/sites-available/0xa1.link/work"
    }

    provisioner "file" {
        source = "${path.module}/files/enable.sh"
        destination = "/tmp/enable.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/enable.sh",
            "/tmp/enable.sh 0xa1.link work"
        ]
    }

    connection {
        type = "ssh"
        user = var.ssh_user
        host = var.ssh_host
        port = var.ssh_port
        private_key = file(var.pvt_key)
    }
}