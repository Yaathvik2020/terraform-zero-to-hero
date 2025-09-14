# MIGRATION TO TERRAFORM & DRIFT DETECTION

1. Define an import block: You start by defining an import block in your Terraform configuration (e.g., in a .tf file). This block specifies the existing resource you want to import and the desired name for its corresponding Terraform resource.

       import {
         id = "existing_resource_id" # The actual ID of the resource in your cloud provider
         to = aws_s3_bucket.example   # The desired Terraform resource type and name
        }
    
  2.Run terraform plan -generate-config-out: You then execute the terraform plan command with the -generate-config-out flag,         specifying the path to a new file where the generated configuration should be written.
  
     terraform plan -generate-config-out=generated_config.tf
     
3.Execute the terraform import Command.
Use the terraform import command, specifying the Terraform resource address and the unique ID of the existing AWS EC2 instance. The resource address combines the resource type and its local name (e.g., aws_instance.example_instance). 

       terraform import aws_instance.example_instance i-0abcdef1234567890
