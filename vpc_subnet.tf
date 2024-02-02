#VPC 생성하기
resource "aws_vpc" "groomVPC" {
  cidr_block = "10.10.0.0/16"
}

#서브넷 생성하기1 ( 가용영역A )
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Web a"
  }
}

#서브넷 생성하기2 ( 가용영역C )
resource "aws_subnet" "public_subnet_c" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Web c"
  }
}

#서브넷 생성하기3 ( 가용영역A )
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private App a"
  }
}

#서브넷 생성하기4 ( 가용영역C )
resource "aws_subnet" "private_subnet_c" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Private App c"
  }
}

#서브넷 생성하기5 ( 가용영역A )
resource "aws_subnet" "db_private_subnet_a" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private DB a"
  }
}

#서브넷 생성하기6 ( 가용영역C )
resource "aws_subnet" "db_private_subnet_c" {
  vpc_id     = aws_vpc.groomVPC.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Private DB c"
  }
}






