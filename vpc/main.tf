# Internet VPC
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr_blocks}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "vpc-${var.project}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "igw-${var.project}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }
}

# Subnets
resource "aws_subnet" "main-public-subnet" {
    count = "${length(var.public_subnets_cidr_blocks)}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${element(var.public_subnets_cidr_blocks, count.index)}"
    map_public_ip_on_launch = "true"
    availability_zone = "${element(var.aws_azs, count.index)}"

    tags {
        Name = "public-subnet-${var.project}-${count.index}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }

    depends_on = ["aws_internet_gateway.main-gw"]
}

resource "aws_subnet" "main-private-subnet" {
    count = "${length(var.private_subnets_cidr_blocks)}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${element(var.private_subnets_cidr_blocks, count.index)}"
    map_public_ip_on_launch = "true"
    availability_zone = "${element(var.aws_azs, count.index)}"

    tags {
        Name = "private-subnet-${var.project}-${count.index}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }

    depends_on = ["aws_internet_gateway.main-gw"]
}

resource "aws_eip" "nat_gateway" {
    count = "${length(var.public_subnets_cidr_blocks)}"
    vpc = true
}

resource "aws_nat_gateway" "main" {
    count = "${length(var.public_subnets_cidr_blocks)}"
    allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
    subnet_id     = "${element(aws_subnet.main-public-subnet.*.id, count.index)}"
    
    tags {
        Name = "nat_gateway-${var.project}-${count.index}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }

    depends_on = ["aws_internet_gateway.main-gw"]
}

# Route Tables
resource "aws_route_table" "main-public-route-table" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags {
        Name = "public-route-table-${var.project}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }

    depends_on = ["aws_internet_gateway.main-gw"]
}

resource "aws_route_table" "main-private-route-table" {
    count = "${length(var.public_subnets_cidr_blocks)}"
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${element(aws_nat_gateway.main.*.id, count.index)}"
    }

    tags {
        Name = "private-route-table-${var.project}-${count.index}",
        Owner = "${var.owner}",
        Project = "${var.project}"
    }

    depends_on = ["aws_nat_gateway.main"]
}

# Route Associations Public
resource "aws_route_table_association" "main-public-route-association" {
    count = "${length(var.public_subnets_cidr_blocks)}"
    subnet_id = "${element(aws_subnet.main-public-subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.main-public-route-table.id}"

    depends_on = [
        "aws_route_table.main-public-route-table",
        "aws_subnet.main-public-subnet",
    ]
}

resource "aws_route_table_association" "main-private-route-association" {
    count = "${length(var.private_subnets_cidr_blocks)}"
    subnet_id = "${element(aws_subnet.main-private-subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.main-private-route-table.*.id, count.index)}"

    depends_on = ["aws_route_table.main-private-route-table"]
}
