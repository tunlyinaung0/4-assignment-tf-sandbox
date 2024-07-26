resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "${terraform.workspace}-igw"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
    tags = {
        Name = "${terraform.workspace}-public-subnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${terraform.workspace}-public-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}