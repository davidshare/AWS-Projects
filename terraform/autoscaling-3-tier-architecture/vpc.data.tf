data "aws_vpc" "tersu" {
  filter {
    name   = "tag:Name"
    values = ["Tersu-Main"]
  }
}