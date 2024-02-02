# Web Launch Template
resource "aws_launch_template" "web-lt" {
  name_prefix   = "web-lt-"
  image_id      = "ami-0bc4327f3aabf5b71"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.goormVPC-sg.id]

  user_data = base64encode(<<-EOF
                #!/bin/bash
                JENKINS_SSH_PUBLIC_KEY=""
                echo $JENKINS_SSH_PUBLIC_KEY >> ~ec2-user/.ssh/authorized_keys
                EOF
             )
}

# Web Auto Scaling Group 설정
resource "aws_autoscaling_group" "web-asg" {
  name = "web-asg"

  launch_template {
    id      = aws_launch_template.web-lt.id
    version = "$Latest"
  }

  vpc_zone_identifier     = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
  min_size                = 1
  max_size                = 3
  desired_capacity        = 1
  health_check_type       = "EC2"
  health_check_grace_period = 300
  target_group_arns       = [aws_lb_target_group.web-tg.arn]
  force_delete            = true

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

# App Launch Template
resource "aws_launch_template" "app-lt" {
  name_prefix   = "app-lt-"
  image_id      = "ami-0bc4327f3aabf5b71"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.goormVPC-sg.id]
}

# App Auto Scaling Group 설정
resource "aws_autoscaling_group" "app-asg" {
  name = "app-asg"

  launch_template {
    id      = aws_launch_template.app-lt.id
    version = "$Latest"
  }

  vpc_zone_identifier     = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_c.id]
  min_size                = 1
  max_size                = 3
  desired_capacity        = 1
  health_check_type       = "EC2"
  health_check_grace_period = 300
  target_group_arns       = [aws_lb_target_group.web-tg.arn]
  force_delete            = true

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}