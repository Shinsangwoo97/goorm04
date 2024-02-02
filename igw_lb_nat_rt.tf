#인터넷 게이트웨이 생성하기
resource "aws_internet_gateway" "goorm-igw" {
  vpc_id = aws_vpc.goormVPC.id

  tags = {
    Name = "Internet GW"
  }
}

# Web ALB
resource "aws_lb" "web-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.goormVPC-sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

# Web ALB Target Group
resource "aws_lb_target_group" "web-tg" {
  name     = "web-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.groomVPC.id
}

# Web ALB Listener
resource "aws_lb_listener" "web-lb-listener" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

# WEB 라우팅 테이블 생성하기
resource "aws_route_table" "web-route-table" {
  vpc_id = aws_vpc.goormVPC.id

  route {
    cidr_block = "0.0.0.0/0" #인터넷 게이트웨이 
    gateway_id = aws_internet_gateway.goorm-igw.id
  }

  tags = {
    Name = "WebRouteTable"
  }
}

# WEB 라우팅 테이블 어소시에이션 생성하기1
resource "aws_route_table_association" "web-route-table-association-a" {
  subnet_id      = aws_subnet.public_subnet_a.id 
  route_table_id = aws_route_table.web-route-table.id
}

# WEB 라우팅 테이블 어소시에이션 생성하기2
resource "aws_route_table_association" "web-route-table-association-c" {
  subnet_id      = aws_subnet.public_subnet_c.id 
  route_table_id = aws_route_table.web-route-table.id
}

# NAT
resource "aws_eip" "goorm-nat-eip" {
	domain = "vpc"
}

resource "aws_nat_gateway" "goorm-nat-gateway" {
  allocation_id = aws_eip.goorm-nat-eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "NatGateway"
  }
}

# App NLB
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.goormVPC-sg.id]
  subnets            = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_c.id]
}

# App NLB Target Group
resource "aws_lb_target_group" "app-tg" {
  name     = "app-target-group"
  port = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.groomVPC.id
}

# App NLB Listener
resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = 8080 
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}


# APP 라우팅 테이블 생성하기
resource "aws_route_table" "app-route-table" {
  vpc_id = aws_vpc.goormVPC.id

  route {
    cidr_block = "0.0.0.0/0" #인터넷 게이트웨이 
    gateway_id = aws_internet_gateway.goorm-nat-gateway.id
  }

  tags = {
    Name = "APPRouteTable"
  }
}

# APP 라우팅 테이블 어소시에이션 생성하기1
resource "aws_route_table_association" "web-route-table-association-a" {
  subnet_id      = aws_subnet.private_subnet_a.id 
  route_table_id = aws_route_table.app-route-table.id
}

# APP 라우팅 테이블 어소시에이션 생성하기2
resource "aws_route_table_association" "web-route-table-association-c" {
  subnet_id      = aws_subnet.private_subnet_c.id 
  route_table_id = aws_route_table.app-route-table.id
}

# DB 라우팅 테이블 생성하기
resource "aws_route_table" "db-route-table" {
  vpc_id = aws_vpc.goormVPC.id

  route {
    cidr_block = "0.0.0.0/0" #인터넷 게이트웨이 
    gateway_id = aws_internet_gateway.goorm-nat-gateway.id
  }

  tags = {
    Name = "DBRouteTable"
  }
}

# DB 라우팅 테이블 어소시에이션 생성하기1
resource "aws_route_table_association" "db-route-table-association-a" {
  subnet_id      = aws_subnet.db_private_subnet_a.id 
  route_table_id = aws_route_table.db-route-table.id
}

# DB 라우팅 테이블 어소시에이션 생성하기2
resource "aws_route_table_association" "db-route-table-association-c" {
  subnet_id      = aws_subnet.db_private_subnet_c.id 
  route_table_id = aws_route_table.db-route-table.id
}







