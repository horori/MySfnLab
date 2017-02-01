# step2lambda
#
# This will build a Lambda function by using sfn-lambda
# Python script to load = "./lambda/python2.7/helloworld.py"
#
# @see: https://github.com/sparkleformation/sfn-lambda
#
# @example Usage to generate CloudFormation JSON template
#   ```bash
#   bundle exec sfn print -file step2lambda
#   ```
# @example Usage to create Lambda function on AWS
#   ```bash
#   bundle exec sfn create STACKNAME -file step2lambda
#   ```
# To use "create" option make sure you set the following environment variables.
# ENV['AWS_ACCESS_KEY_ID'] 
# ENV['AWS_SECRET_ACCESS_KEY'] 
# ENV['AWS_REGION']
#

SparkleFormation.new(:step2lambda, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'
  description 'Just to create lambda function with IAM Role.'

  # Resources/Step2lambdaRole (AWS::IAM::Role)
  dynamic!(:role, "step2lambda") do
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

  # Resources/Step2lambdaPolicy (AWS::IAM::Policy)
  dynamic!(:policy, "step2lambda") do
    properties do
      policy_document do
        version "2012-10-17"
        statement [
          {
              # Permission for CloudWatch
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
      policy_name "Step2lambdaPolicy"
      roles [ref!(:Step2lambdaRole)]
    end
  end

  # Resources/HelloworldHogeHogeLambdaFunction (AWS::Lambda::Function)
  lambda!(:helloworld, "hoge_hoge", function_name: "helloworld", role: attr!("Step2lambdaRole", "Arn"), handler: 'my_handler').properties do
    memory_size 128
    timeout 30
    environment do
      variables do
        hoge01 "value01"
        hoge02 "value02"
      end
    end
  end
end
