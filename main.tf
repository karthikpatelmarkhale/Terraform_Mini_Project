
provider "aws" {
    region = "us-east-1"
  
}

# 1. create a VPC  - 10.81.0.0/16
resource "aws_vpc" "PROD_VPC" {
    cidr_block = "10.81.0.0/16"
    tags = {
        Name = "PROD_VPC"
    }
}

# 2. Create Internet Gateway 
resource "aws_internet_gateway" "PROD_IGW" {
    vpc_id = aws_vpc.PROD_VPC.id
    tags = {
        Name = "PROD_IGW"
    }
}

#  3. Create Custom Route Table 
resource "aws_route_table" "PROD_RT" {
    vpc_id = aws_vpc.PROD_VPC.id

route {
      cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.PROD_IGW.id
        }

    tags = {
      Name = "Prod-RT"
    }
  
}

#   4. Create a public Subnet  -- 10.81.3.0/24
resource "aws_subnet" "PROD_PUBLIC_SUBNET" {
    vpc_id = aws_vpc.PROD_VPC.id
    cidr_block = "10.81.3.0/24"

    tags = {
        Name = "PROD_PUBLIC_SUBNET"
    }
}

# 5. Associate Route Table with Subnet  
resource "aws_route_table_association" "PROD_RT_ASSOCIATION" {
    subnet_id = aws_subnet.PROD_PUBLIC_SUBNET.id
    route_table_id = aws_route_table.PROD_RT.id
     
}

# 6. Create Security Group to allow port 22,80,443 or all ports , traffic 
resource "aws_security_group" "PROD_SG" {
    name        = "PROD_SG"
    description = "Allow all inbound traffic"
    vpc_id      = aws_vpc.PROD_VPC.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    tags = {
        Name = "PROD_SG"
    }
}

#  7. Create a network interface with an ip in the subnet that was created in step 4  
resource "aws_network_interface" "PROD_NI" {
    subnet_id       = aws_subnet.PROD_PUBLIC_SUBNET.id
    private_ips     = ["10.81.3.33"]
    security_groups = [aws_security_group.PROD_SG.id]
    tags = {
        Name = "PROD_NI"
    }
}

#  8. Assign an elastic IP to the network interface created in step 7 
resource "aws_eip" "PROD_EIP" {
    network_interface = aws_network_interface.PROD_NI.id
    domain = "vpc"
    tags = {
        Name = "PROD_EIP"
    }
}
# 9. Create an ec2  server - LAUNCH APLICATION IN IT 
resource "aws_instance" "PROD_SERVER" {
  
  ami = "ami-004d1eaf8eaa0107d"
  instance_type = "t2.micro"
  key_name = "karthikkey"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.PROD_NI.id
    }
  
  user_data = file("facebook.sh")

  tags = {
    Name = "PROD_SERVER"
  }



}

output "fb-eip" {
    value = aws_eip.PROD_EIP.public_ip
}