resource "aws_iam_policy" "lightspin-ec2-scan" {
  count       = var.enable_ec2_scan ? 1 : 0
  name        = "lightspin-ec2-scan-policy"
  path        = "/"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:DeleteSnapshot",
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringLikeIfExists": {
                    "ec2:ResourceTag/used_by": "lightspin - ec2 scan"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:CopySnapshot",
                "ec2:ModifySnapshotAttribute",
                "ec2:CreateTags",
                "ec2:CreateSnapshot",
                "kms:RevokeGrant",
                "kms:ReEncryptTo",
                "kms:DescribeKey",
                "kms:CreateGrant",
                "kms:ReEncryptFrom",
		        "kms:GenerateDataKeyWithoutPlaintext"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "Lightspin-extendedAuditPermissions" {
  name        = "Lightspin-extendedAuditPermissions-policy"
  path        = "/"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "health:DescribeAffectedEntities",
                "backup:List*",
                "eks:ListTagsForResource",
                "wafv2:GetWebACLForResource",
                "ec2:GetEbsEncryptionByDefault",
                "wafv2:GetLoggingConfiguration",
                "waf:GetLoggingConfiguration",
                "ses:ListReceiptFilters",
                "backup:DescribeGlobalSettings",
                "health:DescribeAffectedAccountsForOrganization",
                "ses:GetEmailIdentity",
                "glue:GetSecurityConfiguration",
                "ec2:SearchTransitGatewayRoutes",
                "kms:GetKeyRotationStatus",
                "dynamodb:DescribeExport",
                "codebuild:ListProjects",
                "apigateway:GET",
                "kendra:ListDataSources",
                "kendra:ListTagsForResource",
                "ses:GetDedicatedIps",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken",
                "kendra:ListIndices",
                "ses:GetConfigurationSetEventDestinations",
                "ses:GetAccount",
                "ecr:BatchGetImage",
                "kendra:DescribeDataSource",
                "glacier:GetVaultLock",
                "elasticmapreduce:GetManagedScalingPolicy",
                "kafka:ListClusters",
                "lambda:GetLayerVersion",
                "codebuild:GetResourcePolicy",
                "health:DescribeHealthServiceStatusForOrganization",
                "kms:ListResourceTags",
                "health:DescribeEventTypes",
                "backup:GetBackupVaultNotifications",
                "backup:GetBackupVaultAccessPolicy",
                "backup:GetBackupSelection",
                "backup:GetBackupPlan",
                "ses:ListDedicatedIpPools",
                "health:DescribeEntityAggregates",
                "ses:ListConfigurationSets",
                "glacier:GetDataRetrievalPolicy",
                "backup:GetSupportedResourceTypes",
                "glue:GetConnection",
                "health:DescribeEventAggregates",
                "elasticfilesystem:DescribeFileSystemPolicy",
                "ses:GetConfigurationSet",
                "elasticmapreduce:GetAutoTerminationPolicy",
                "dynamodb:DescribeKinesisStreamingDestination",
                "cloudtrail:GetInsightSelectors",
                "dynamodb:ListExports",
                "health:DescribeEventsForOrganization",
                "health:DescribeEvents",
                "cognito-identity:DescribeIdentityPool",
                "codebuild:BatchGetProjects",
                "ecr:GetRegistryPolicy",
                "health:DescribeEventDetailsForOrganization",
                "health:DescribeAffectedEntitiesForOrganization",
                "kendra:DescribeIndex",
                "cloudtrail:ListTrails",
                "lambda:GetFunction",
                "health:DescribeEventDetails",
                "elasticfilesystem:DescribeAccessPoints",
                "glue:GetTags",
                "ses:DescribeActiveReceiptRuleSet",
                "backup:DescribeBackupVault",
                "backup:DescribeRecoveryPoint"
            ],
            "Resource": "*"
        },
        {
          "Action": [
            "s3:GetObject",
            "s3:GetBucketLocation",
            "s3:GetObjectTagging",
            "s3:ListBucket"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:s3:::*terraform*",
            "arn:aws:s3:::*tfstate*",
            "arn:aws:s3:::*tf?state*"
          ],
          "Sid": "LightspinGetTFState"
    }
    ]
}
EOF
}

resource "aws_iam_role" "Lightspin-secaudit-role" {
  name               = "Lightspin-SecurityAuditRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          "AWS" : "arn:aws:iam::${var.lightspin_account_id}:root"
        }
        Condition = {
          "StringEquals" : {
            "sts:ExternalId" : "${var.external_id}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSOrganizationsReadOnlyAccess-attach" {
  role       = aws_iam_role.Lightspin-secaudit-role.name
  policy_arn = data.aws_iam_policy.AWSOrganizationsReadOnlyAccess.arn
}

resource "aws_iam_role_policy_attachment" "SecurityAudit-attach" {
  role       = aws_iam_role.Lightspin-secaudit-role.name
  policy_arn = data.aws_iam_policy.SecurityAudit.arn
}

resource "aws_iam_role_policy_attachment" "ViewOnlyAccess-attach" {
  role       = aws_iam_role.Lightspin-secaudit-role.name
  policy_arn = data.aws_iam_policy.ViewOnlyAccess.arn
}

resource "aws_iam_role_policy_attachment" "lightspin-ec2-scan-attach" {
  count      = var.enable_ec2_scan ? 1 : 0
  role       = aws_iam_role.Lightspin-secaudit-role.name
  policy_arn = aws_iam_policy.lightspin-ec2-scan[0].arn
}

resource "aws_iam_role_policy_attachment" "Lightspin-extendedAuditPermissions-attach" {
  role       = aws_iam_role.Lightspin-secaudit-role.name
  policy_arn = aws_iam_policy.Lightspin-extendedAuditPermissions.arn
}
