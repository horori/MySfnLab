import boto3
import json
import os
import cfnresponse

def my_handler(event, context):
    '''
    Test Python code for cfnresponse
    '''
    print(event)
    try:
        print(os.environ['hoge01'])
        print(os.environ['hoge02'])
        print(event['hoge11'])
        print(event['hoge12'])
    except:
        print("Exception")
    response_data = {}
    response_data['result'] = "Hello World from Python on Lambda!"

    # Send SUCCESS signal to AWS URL for CloudFormation Stack
    cfnresponse.send(event, context, cfnresponse.SUCCESS, response_data, "CustomResourcePhysicalID")
