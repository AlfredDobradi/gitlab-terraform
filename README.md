# gitlab-terraform

![Lint Code Base](https://github.com/AlfredDobradi/gitlab-terraform/workflows/Lint%20Code%20Base/badge.svg)

I recently started learning about Terraform and have been contemplating installing a Gitlab instance for a while as well so I thought I might as well do both at the same time.

I'm sure it could be a bit cleaner (looking at you `null_provider`) but it's something to improve on.

It installs a single Gitlab instance on a remote docker. You might want to edit the `providers.tf` file and use the `sample.tfvars` file to manage the nginx config if you're planning on running behind an nginx proxy.

### Plans

* Refactor more stuff to variables
* Create and connect CI runners with Terraform
