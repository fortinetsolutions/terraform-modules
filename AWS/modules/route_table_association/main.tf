provider "aws" {
  region     = var.aws_region
}

resource "aws_route_table_association" "rta" {
  subnet_id      = var.subnet_ids
  route_table_id = var.route_table_id
}
