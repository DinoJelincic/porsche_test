output "id" {
    value = aws_iam_role.ec2_role.id
  
}
output "instance_profile_name" {
    value = aws_iam_instance_profile.instance_profile.name
  
}
output "instance_profile_id" {
    value = aws_iam_instance_profile.instance_profile.id
  
}