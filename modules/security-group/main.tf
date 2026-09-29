resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id            = aws_security_group.this.id
  description                  = lookup(each.value, "description", null)
  cidr_ipv4                    = lookup(each.value, "cidr_ipv4", null)
  from_port                    = lookup(each.value, "from_port", null)
  to_port                      = lookup(each.value, "to_port", null)
  ip_protocol                  = each.value.ip_protocol
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id            = aws_security_group.this.id
  description                  = lookup(each.value, "description", null)
  cidr_ipv4                    = lookup(each.value, "cidr_ipv4", null)
  from_port                    = lookup(each.value, "from_port", null)
  to_port                      = lookup(each.value, "to_port", null)
  ip_protocol                  = each.value.ip_protocol
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", null)
}