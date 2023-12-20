#Région AWS
provider "aws" {
  region = "us-east-1"
}

#EC2
resource "aws_instance" "web_server" {
  ami           = "ami-06aa3f7caf3a30282"  # ubuntu
  instance_type = "t2.micro"
  key_name      = "Keypair"
  #attachement VPC
  vpc_security_group_ids=[aws_security_group.web_sg.id]

  provisioner "remote-exec" {
      inline = [
          "sudo apt update -y",
          "sudo apt-get install -y apache2",
          "sudo echo 'Hello Terraform' | sudo tee /var/www/html/index.html",
          "sudo service apache2 restart"
      ]

      connection {
          type        = "ssh"
          user        = "ubuntu"
          private_key = file("./Keypair.pem")
          host        = aws_instance.web_server.public_ip
      }
  }
  tags = {
    Name = "InstanceWeb"
  }
}
#Groupe de sécurité
resource "aws_security_group" "web_sg" {
  name        = "security_group"
  description = "Autorisation du traffic sur le port 80"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port  = 0
    to_port  = 0
    protocol  = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
    ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}