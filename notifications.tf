data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid     = "AllowEventBridgeAndCloudWatchPublish"
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "cloudwatch.amazonaws.com"]
    }

    resources = [aws_sns_topic.notifications.arn]
  }
}

resource "aws_sns_topic_policy" "notifications_policy" {
  arn    = aws_sns_topic.notifications.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_cloudwatch_event_rule" "pipeline_state_change" {
  name        = "terraform-employee-api-pipeline-state"
  description = "Send readable SNS alerts when CodePipeline succeeds or fails"

  event_pattern = jsonencode({
    source      = ["aws.codepipeline"]
    detail-type = ["CodePipeline Pipeline Execution State Change"]
    detail = {
      pipeline = [aws_codepipeline.terraform_pipeline.name]
      state    = ["SUCCEEDED", "FAILED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "pipeline_sns" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_change.name
  target_id = "SendFormattedEmailToSNS"
  arn       = aws_sns_topic.notifications.arn

  input_transformer {
    input_paths = {
      pipeline    = "$.detail.pipeline"
      state       = "$.detail.state"
      executionId = "$.detail.execution-id"
      region      = "$.region"
      time        = "$.time"
    }

    input_template = jsonencode({
      alert        = "CodePipeline Execution Update"
      pipeline     = "<pipeline>"
      status       = "<state>"
      execution_id = "<executionId>"
      region       = "<region>"
      time_utc     = "<time>"
      console_url  = "https://<region>.console.aws.amazon.com/codesuite/codepipeline/pipelines/<pipeline>/executions/<executionId>/timeline"
    })
  }
}
