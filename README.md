# Serverless Employee Management API (Terraform + AWS CI/CD)

A serverless CRUD API for managing employee records on AWS, provisioned with Terraform and automated through AWS CodePipeline and AWS CodeBuild.

## Architecture

- **API Layer:** Amazon API Gateway (HTTP API, `prod` stage)
- **Compute:** AWS Lambda (`terraform-demo-lambda`, Python 3.13)
- **Database:** Amazon DynamoDB (`EmployeeTerraformDemo`)
- **Remote State:** Amazon S3 (`default-terraform-state-803817393192`) with DynamoDB state locking (`terraform-state-lock`)
- **Monitoring & Alerts:** Amazon CloudWatch Dashboard (`Employee-API_New-Dashboard`), 5xx & Lambda Error Alarms, and Amazon SNS (`terraform-notifications`)
- **CI/CD:** GitHub (`main`) → AWS CodePipeline (`terraform-employee-api-pipeline`) → AWS CodeBuild (`terraform-employee-api-build`)
- **Region:** `ap-southeast-2` (Sydney)

## API Endpoints

| Method | Route | Description |
| :--- | :--- | :--- |
| `POST` | `/prod/employee` | Create a new employee record |
| `GET` | `/prod/employee/{EmployeeID}` | Fetch an employee by ID |
| `PUT` | `/prod/employee/{EmployeeID}` | Update an employee's name |
| `DELETE` | `/prod/employee/{EmployeeID}` | Delete an employee by ID |

### Example Requests

```bash
# Create an employee
curl -X POST "<API_URL>/employee" \
  -H "Content-Type: application/json" \
  -d '{"EmployeeID":"101","Name":"Clark"}'

# Get an employee
curl "<API_URL>/employee/101"

# Update an employee
curl -X PUT "<API_URL>/employee/101" \
  -H "Content-Type: application/json" \
  -d '{"Name":"Clark Kent"}'

# Delete an employee
curl -X DELETE "<API_URL>/employee/101"
```

## CI/CD Workflow

Pushing commits to `main` automatically triggers **AWS CodePipeline** via the GitHub App connection (`github-employee-api-conn`). CodePipeline passes the source bundle to **AWS CodeBuild**, which executes `buildspec.yml` to run:

1. `terraform init`
2. `terraform validate`
3. `terraform plan`
4. `terraform apply -auto-approve`
