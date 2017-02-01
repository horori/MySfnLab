# step3custom
#
# This will build a Lambda function with
# ./lambda/python2.7/helloworld.py, and then trigger the function.
# Finally get result and export to Output.
#
# @example Usage to generate CloudFormation JSON template
#   ```bash
#   bundle exec sfn print -file step3custom
#   ```
# @example Usage to create Lambda function on AWS
#   ```bash
#   bundle exec sfn create STACKNAME -file step3custom
#   ```
# To use "create" option make sure you set the following environment variables.
# ENV['AWS_ACCESS_KEY_ID'] 
# ENV['AWS_SECRET_ACCESS_KEY'] 
# ENV['AWS_REGION']
#

SparkleFormation.new(:step3custom, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'
  description 'Create lambda function with IAM Role, trigger the function and output the result.'

  # Resources/Step3customRole (AWS::IAM::Role)
  dynamic!(:role, "step3custom") do
    properties do
      assume_role_policy_document {
        version '2012-10-17'
        statement [
          {
            Effect: 'Allow',
            Principal: {
              Service: 'lambda.amazonaws.com'
            },
            Action: 'sts:AssumeRole'
          }
        ]
      }
    end
  end

  # Resources/Step3customPolicy (AWS::IAM::Policy)
  dynamic!(:policy, "step3custom") do
    properties do
      policy_document do
        version "2012-10-17"
        statement [
          {
              Effect: "Allow",
              Action: [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents" 
              ],
              Resource: "arn:aws:logs:*:*:*" 
          }
        ]
      end
      policy_name "step3customPolicy"
      roles [ref!(:step3customRole)]
    end
  end

  # Resources/HelloworldHogeHogeLambdaFunction (AWS::Lambda::Function)
  lambda!(:helloworld, "hoge_hoge", function_name: "helloworld", role: attr!("step3customRole", "Arn"), handler: 'my_handler').properties do
    memory_size 512
    timeout 300
    environment do
      variables do
        hoge01 "value01"
        hoge02 "value02"
      end
    end
  end

  # Resource/ExecHelloWorld (Custom::ExecHelloWorld)
  resources("ExecHelloWorld") do
    type "Custom::ExecHelloWorld"
    properties do
      service_token attr!("HelloworldHogeHogeLambdaFunction", 'Arn')
      hoge11 "value11"
      hoge12 "value12"
    end
  end

  # Output/CustomResouceResult - parse Python code responseData[key]
  outputs.set!("CustomResouceResult") do
    description "Custom::ExecHelloWorld return value"
    value attr!("ExecHelloWorld", "result")
  end
end
