data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  count              = "${var.role == "" ? 1 : 0}"
  name               = "${var.role_name != "" ? var.role_name : var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy_document.json}"
}

resource "aws_iam_role_policy" "lambda_policy" {
  count  = "${var.policy == "" ? 0 : 1}"
  name   = "LambdaRolePolicy"
  role   = "${aws_iam_role.lambda.id}"
  policy = "${var.policy}"
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  count      = "${var.policy_arn == "" ? 0 : 1}"
  name       = "LambdaRolePolicyAttachment"
  roles      = ["${aws_iam_role.lambda.id}"]
  policy_arn = "${var.policy_arn}"
}
