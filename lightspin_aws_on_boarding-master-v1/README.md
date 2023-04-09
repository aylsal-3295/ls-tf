lightspin aws iam cross account role terraform module
===========

A terraform module to provide a the necessary configuration for lightspin aws security audit.


Usage
-----

```hcl
module "lightspin_aws_on_boarding" {
  source = "./modules/lightspin_aws_on_boarding"
}

output "role_arn" {
  value = "${module.lightspin_aws_on_boarding.role_arn}"
}
```


Outputs
=======
 - `role_arn` - the newly created IAM role arn
 - `external_id` - the external id secret condition which allows a trusted sts connection


 
