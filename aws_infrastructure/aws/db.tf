resource "aws_db_instance" "boundary" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "11.8"
  instance_class      = "db.t2.micro"
  name                = "boundary"
  username            = "boundary"
  password            = "boundarydemo"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.boundary.name
  publicly_accessible    = true

  tags = {
    Name = "${var.tag}-db"
  }
}

# resource "aws_db_instance" "demo-postgres" {
#   allocated_storage   = 20
#   storage_type        = "gp2"
#   engine              = "postgres"
#   engine_version      = "11.8"
#   instance_class      = "db.t2.micro"
#   name                = "demo-postgres"
#   username            = "postgres"
#   password            = "postgres"
#   skip_final_snapshot = true

#   vpc_security_group_ids = [aws_security_group.demo-db.id]
#   db_subnet_group_name   = aws_db_subnet_group.demo-db.name
#   publicly_accessible    = true

#   tags = {
#     Name = "${var.tag}-db"
#   }
# }

resource "aws_security_group" "db" {
  vpc_id = var.aws_vpc_id

  tags = {
    Name = "${var.tag}-db-${random_pet.test.id}"
  }
}

# resource "aws_security_group" "demo-db" {
#   vpc_id = var.aws_vpc_id

#   tags = {
#     Name = "${var.tag}-db-${random_pet.test.id}"
#   }
# }

resource "aws_security_group_rule" "allow_controller_sg" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.controller.id
}

resource "aws_security_group_rule" "allow_any_ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.db.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_subnet_group" "boundary" {
  name       = "${var.tag}-boundary"
  subnet_ids = var.aws_public_subnets

  tags = {
    Name = "${var.tag}-db-${random_pet.test.id}"
  }
}

# resource "aws_db_subnet_group" "demo-db" {
#   name       = "${var.tag}-demo-db"
#   subnet_ids = var.aws_private_subnets

#   tags = {
#     Name = "${var.tag}-db-${random_pet.test.id}"
#   }
# }
