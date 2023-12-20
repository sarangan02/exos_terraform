# Définition du fournisseur AWS
provider "aws" {
  region = "eu-west-3"  # Région Paris
}

# Création du VPC
resource "aws_vpc" "mon_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MonVPC"
  }
}

# Création du subnet dans le VPC
resource "aws_subnet" "mon_subnet" {
  vpc_id                  = aws_vpc.mon_vpc.id
  cidr_block             = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"  # Zone de disponibilité dans la région Paris

  # Autres options facultatives
  map_public_ip_on_launch = true

  tags = {
    Name = "MonSubnet"
  }
}