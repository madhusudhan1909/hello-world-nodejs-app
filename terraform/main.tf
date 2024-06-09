provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "cluster" {
  name = "hello-world-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "public.ecr.aws/q6g9n2l9/pearl-test:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-05fa270580ea5da44", "subnet-07026d6cdadb34b73"]  # Replace these with your existing subnet IDs
    security_groups  = ["sg-080632b19e474257b"]  # Replace this with your existing security group ID
    assign_public_ip = true
  }
}

resource "aws_security_group" "sg" {
  name        = "allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "vpc-0854d537bed2935cd"  # Replace this with your existing VPC ID

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


