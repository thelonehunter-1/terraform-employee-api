resource "aws_iam_role" "lambda_role" {

  name = "terraform-demo-lambda-role"

  assume_role_policy = jsonencode(

    {
      Version = "2012-10-17"

      Statement = [

        {
          Action = "sts:AssumeRole"
          Effect = "Allow"

          Principal = {

            Service = "lambda.amazonaws.com"

          }

        }

      ]


    }


  )

}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"


}

resource "aws_lambda_function" "demo" {
  function_name = "terraform-demo-lambda"
  filename      = "lambda/lambda_function.zip"

  source_code_hash = filebase64sha256(
    "lambda/lambda_function.zip"
  )

  role = aws_iam_role.lambda_role.arn

  handler = "lambda_function.lambda_handler"

  runtime = "python3.13"

}

resource "aws_iam_role_policy" "lambda_dynamodb" {

  name = "terraform-demo-lambda-dynamodb"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode(
    {
      Version = "2012-10-17"

      Statement = [
        {
          Effect = "Allow"

          Action = [
            "dynamodb:PutItem",
            "dynamodb:GetItem"

          ]
          Resource = aws_dynamodb_table.employee.arn
        }



      ]


  })


}
