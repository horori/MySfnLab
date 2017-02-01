# step1ec2
#
# This will build a simple EC2 instance.
# 
# To create an instance on AWS, make sure you set the following environment variables.
# ENV['AWS_ACCESS_KEY_ID'] 
# ENV['AWS_SECRET_ACCESS_KEY'] 
# ENV['AWS_REGION']
#
# @example Usage to generate CloudFormation JSON template
#   ```bash
#   bundle exec sfn print -file step1ec2
#   ```
# @example Usage to create instance on AWS
#   ```bash
#   bundle exec sfn create STACKNAME -file step1ec2
#   ```
# @see: http://www.sparkleformation.io/docs/guides/getting-started.html#create-a-template

SparkleFormation.new(:step1ec2, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'
  description 'Sparkle Guide Compute Template'

  # Parameters
  parameters do
    sparkle_image_id.type 'String'
    sparkle_ssh_key_name.type 'String'
    sparkle_flavor do
      type 'String'
      default 't2.micro'
      allowed_values ['t2.micro', 't2.small']
    end
  end

  # Resources/SparkleEc2Instance (AWS::EC2::Instance) 
  dynamic!(:ec2_instance, :sparkle) do
    properties do
      image_id ref!(:sparkle_image_id)
      instance_type ref!(:sparkle_flavor)
      key_name ref!(:sparkle_ssh_key_name)
    end
  end

  # Outputs/SparklePublicAddress
  outputs.sparkle_public_address do
    description 'Compute instance public address'
    value attr!(:sparkle_ec2_instance, :public_ip)
  end

end
