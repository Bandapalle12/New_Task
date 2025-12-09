data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "ecs_instance" {
  count         = 1
  ami           = data.aws_ami.ecs.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]
  
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.project_name}-cluster >> /etc/ecs/ecs.config
              EOF

  tags = {
    Name = "${var.project_name}-ecs-instance"
  }
}
