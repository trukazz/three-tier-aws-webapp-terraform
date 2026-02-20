
resource "aws_autoscaling_group" "this" {
  name                = "${var.vpc_name}-asg"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = values(var.private_subnet_ids)
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.vpc_name}-lt"
  image_id      = "ami-075f150fc1ca69e71"
  instance_type = "t3.micro"

  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  metadata_options {
    http_tokens = "optional"
  }

  user_data = base64encode(<<EOF
#!/bin/bash

# Update system
dnf update -y

# Install Apache and MySQL client (MariaDB client on AL2023)
dnf install -y httpd mariadb105

# Enable Apache on boot
systemctl enable httpd

# Database connection variables
DB_HOST="${var.db_endpoint}"
DB_USER="${var.db_username}"
DB_PASS="${var.db_password}"

echo "Starting DB readiness checks..." >> /var/log/user-data.log

# Try connecting to the DB for up to 5 minutes
for i in {1..30}; do
  mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" && DB_READY=true && break
  echo "DB not ready yet... attempt $i" >> /var/log/user-data.log
  sleep 10
done

# Start Apache
systemctl start httpd

# Write result to index.html
if [ "$DB_READY" = true ]; then
  echo "<h1>DB Connection Successful</h1>" > /var/www/html/index.html
else
  echo "<h1>DB Connection Failed</h1>" > /var/www/html/index.html
fi

EOF
  )




  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.vpc_name}-asg-instance"
    }
  }
}
