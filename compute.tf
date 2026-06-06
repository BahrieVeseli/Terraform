resource "aws_launch_template" "app_lt" {
  name_prefix   = "master-LT-"
  image_id      = "ami-01e444924a2233b07" # Amazon Linux 2023 në eu-central-1
  instance_type = "t3.micro" 

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd git
              systemctl start httpd
              systemctl enable httpd
              
              # SHËNIM: Zëvendësoje linkun më poshtë me linkun e GitHub të grupit tuaj!
              git clone https://github.com/erzaberisha/grupi6-master-webapp.git /tmp/webapp
              
              rm -f /var/www/html/index.html
              cp /tmp/webapp/* /var/www/html/
              
              systemctl restart httpd
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "master-ec2-instance"
      Environment = "PROD"
      CreatedBy   = "Gentrit-Erza-Bahrie"
      Project     = "DCADD_MASTER"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "master-asg"
  vpc_zone_identifier = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  min_size         = 2
  max_size         = 6
  desired_capacity = 3 

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "asg-instance-master"
    propagate_at_launch = true
  }
}
