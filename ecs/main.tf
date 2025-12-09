resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "hello_task" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = var.docker_image
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.hello_task.arn
  desired_count   = 1

  launch_type = "EC2"
}
