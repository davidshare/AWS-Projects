data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Tersu-Main"]
  }
}