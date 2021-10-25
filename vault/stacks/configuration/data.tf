data "aws_instance" "leader" {

  filter {
    name   = "tag:Name"
    values = ["*-leader"]
  }
}