output "instance_id" {
  value = {
    for name, instance in module.ec2_instance :
    name => instance.instance_id
  }
}

output "public_ip" {
  value =  {
    for name, instance in module.ec2_instance :
    name => instance.public_ip
  }
}

