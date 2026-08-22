import json
import boto3

dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table("EmployeeTerraformDemo")


def lambda_handler(event, context):
   method = event["requestContext"]["http"]["method"]

   if method == "POST":
       body = json.loads(event["body"])

       item = {
             "EmployeeID": body["EmployeeID"],
             "Name": body["Name"]

       }

       table.put_item(Item=item)

       return {
       "statusCode": 200,
       "body": json.dumps(item)

       }
   elif method == "GET":

     employee_id = event["pathParameters"]["EmployeeID"]
     response = table.get_item(
                 Key = {

                          "EmployeeID": employee_id
                     }

             )

     return {
                "statusCode": 200,
                "body": json.dumps(response.get("Item", {}))

             }





#    return {
#            "statusCode":200,
#            "body": "Hello Soumyendra,LETSGO!!!!!!!! I updated the code from Terraform!"
#            }

