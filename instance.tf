 #instance.tf
resource "aws_instance" "master" {
  ami           = "ami-0ff1c68c6e837b183"
  instance_type = "t2.micro"
  count         = 1
  key_name          = "jenkins-key"
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker" {
  ami           = "ami-0ff1c68c6e837b183"
  instance_type = "t2.micro"
  count         = 2
  key_name          = "jenkins-key"
  tags = {
    Name = "worker-${count.index + 1}"
  }
}