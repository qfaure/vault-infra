resource "aws_lb_target_group" "vault" {
  name     = "${local.vault_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vault_demo_vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "vault" {
  count             = length(var.vault_server_names)
  target_group_arn = aws_lb_target_group.vault.arn
  target_id        = aws_instance.vault-server.*.id[count.index]
  port             = 8200
}

resource "aws_lb" "vault" {
  name               = "vault-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vault.id]
  subnets         =     ["subnet-05baa07be1b2d95fc", "subnet-0aa88320e0dd1d2ca", "subnet-0d0f2e5a0b6279017"]//data.aws_subnet_ids.all.ids
}
