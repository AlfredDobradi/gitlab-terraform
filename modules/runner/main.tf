resource "aws_instance" "gitlab_runner" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.runner[0].key_name

    tags = {
        Name = "runner-${var.name}-${count.index+1}"
    }

    provisioner "file" {
        content = templatefile("${path.module}/files/runner.sh", {
            gitlab_token = var.gitlab_token,
            gitlab_url = var.gitlab_url
        })
        destination = "/tmp/runner.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/runner.sh",
            "/tmp/runner.sh"
        ]
    }

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
    }

    count = var.gitlab_runner_num
}

resource "aws_key_pair" "runner" {
    key_name_prefix = "runner-"
    public_key = file("~/.ssh/id_rsa.pub")
    
    count = var.gitlab_runner_num > 0 ? 1 : 0
}