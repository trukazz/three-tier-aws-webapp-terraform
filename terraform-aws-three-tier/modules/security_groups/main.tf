#############################################
#ALB SG
#############################################
resource "aws_security_group" "alb_sg" {
  name        = "${var.vpc_name}-alb_sg"
  description = "alb security group"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

######################################################
#EC2 SG
######################################################

resource "aws_security_group" "ec2_sg" {
  name        = "${var.vpc_name}-ec2_sg"
  description = "ec2 security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  egress {
    description = "allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ec2-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id

  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group_rule" "db_inbound_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "db_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.db_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
