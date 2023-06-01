**REFACTOR YOUR PROJECT USING MODULES**
Let us review the repository from project 17, you will notice that we had a single list of long file for creating all of our resources, but that is not the best way to go about it because it makes our code base vey hard to read and understand therefore making future changes can be quite stressful.

Break down your Terraform codes to have all resources in their respective modules. Combine resources of a similar type into directories within a ‘modules’ directory, for example, like this:

`- modules`

`- ALB: For Apllication Load balancer and similar resources`
`- EFS: For Elastic file system resources`
`- RDS: For Databases resources`
`- Autoscaling: For Autosacling and launch template resources`
`- compute: For EC2 and related resources`
`- VPC: For VPC and netowrking resources such as subnets, roles, e.t.c.`
`- security: for creating security group resources`


Each module shall contain following files:

`- main.tf (or %resource_name%.tf) file(s) with resources blocks`
`- outputs.tf (optional, if you need to refer outputs from any of these resources in your root module)`
`- variables.tf (as we learned before - it is a good practice not to hard code the values and use variables)`

It is also recommended to configure providers and backends sections in separate files but should be placed in the root module

**IMPORTANT**: In the configuration sample from the repository, you can observe two examples of referencing the module

a. Import module as a source and have access to its variables via var keyword:

`module "VPC" {`
  `source = "./modules/VPC"`
  `region = var.region`
  `...`

 b. Refer to a module’s output by specifying the full path to the output variable by using module.%module_name%.%output_name% construction:

 `subnets-compute = module.network.public_subnets-1`

 Refer to the given diagram:

![alt text](./images/tooling_project_15.png)

**Pro-tips:**

1. You can validate your codes before running terraform plan with terraform validate command. It will check if your code is syntactically valid and internally consistent.
   
2. In order to make your configuration files more readable and follow canonical format and style – use terraform fmt command. It will apply Terraform language style conventions and format your .tf files in accordance to them.

3. In order not to delete our S3 buckets when we destroy our infrastructure , We need to add # to our backend.tf file run
`terraform init -migrate-state`
Before we Destroy our infrastructure.