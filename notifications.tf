data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid     = "AllowCodeStarNotificationsPublish"
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com", "cloudwatch.amazonaws.com"]
    }

    resources = [aws_sns_topic.notifications.arn]
  }
}

resource "aws_sns_topic_policy" "notifications_policy" {
  arn    = aws_sns_topic.notifications.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_codestarnotifications_notification_rule" "pipeline_notifications" {
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-failed"
  ]
  name     = "terraform-employee-api-pipeline-notifications"
  resource = aws_codepipeline.terraform_pipeline.arn

  target {
    address = aws_sns_topic.notifications.arn
  }

  depends_on = [aws_sns_topic_policy.notifications_policy]
}
