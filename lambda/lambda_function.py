import json
import boto3
import os

dynamodb = boto3.client("dynamodb")

TABLE_NAME = os.environ["TABLE_NAME"]



def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }

def lambda_handler(event, context):
    method = event["requestContext"]["http"]["method"]
    environment {
            variables = {
                TABLE_NAME = aws_dynamodb_table.employee.name
                }
            }
    # -----------------------------
    # CREATE EMPLOYEE (POST)
    # -----------------------------
    if method == "POST":

        body = json.loads(event["body"])

        employee_id = body["EmployeeID"]
        name = body["Name"]

        dynamodb.put_item(
            TableName=TABLE_NAME,
            Item={
                "EmployeeID": {
                    "S": employee_id
                },
                "Name": {
                    "S": name
                }
            }
        )

        return response(
            200,
            {
                "EmployeeID": employee_id,
                "Name": name,
                "message": "Employee created successfully"
            }
        )

    # -----------------------------
    # GET EMPLOYEE (GET)
    # -----------------------------
    elif method == "GET":

        employee_id = event["pathParameters"]["EmployeeID"]

        result = dynamodb.get_item(
            TableName=TABLE_NAME,
            Key={
                "EmployeeID": {
                    "S": employee_id
                }
            }
        )

        if "Item" not in result:
            return response(
                404,
                {
                    "message": "Employee not found"
                }
            )

        item = result["Item"]

        return response(
            200,
            {
                "EmployeeID": item["EmployeeID"]["S"],
                "Name": item["Name"]["S"]
            }
        )

    # -----------------------------
    # UPDATE EMPLOYEE (PUT)
    # -----------------------------
    elif method == "PUT":

        employee_id = event["pathParameters"]["EmployeeID"]

        body = json.loads(event["body"])

        name = body["Name"]

        dynamodb.update_item(
            TableName=TABLE_NAME,
            Key={
                "EmployeeID": {
                    "S": employee_id
                }
            },
            UpdateExpression="SET #n = :name",
            ExpressionAttributeNames={
                "#n": "Name"
            },
            ExpressionAttributeValues={
                ":name": {
                    "S": name
                }
            }
        )

        return response(
            200,
            {
                "EmployeeID": employee_id,
                "Name": name,
                "message": "Employee updated successfully"
            }
        )

    # -----------------------------
    # DELETE EMPLOYEE (DELETE)
    # -----------------------------
    elif method == "DELETE":

        employee_id = event["pathParameters"]["EmployeeID"]

        dynamodb.delete_item(
            TableName=TABLE_NAME,
            Key={
                "EmployeeID": {
                    "S": employee_id
                }
            }
        )

        return response(
            200,
            {
                "EmployeeID": employee_id,
                "message": "Employee deleted successfully"
            }
        )

    # -----------------------------
    # UNSUPPORTED METHOD
    # -----------------------------
    else:

        return response(
            400,
            {
                "message": f"Unsupported method {method}"
            }
        )
