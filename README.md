**NETWORKING**
Create 4 Private subnets keeping in mind the following principles:

- Make sure you use variables or length() function to determine the number of AZs
- Use variables and cidrsubnet() function to allocate vpc_cidr for subnets
- Keep variables and resources in separate files for better code structure and readability
- Tags all the resources you have created so far. Explore how to use format() and count functions to automatically tag subnets with its respective number.

**Internet Gateways & format() function**

- Create an Internet Gateway in a separate Terraform file internet_gateway.tf

**NAT Gateways**

- Create 1 NAT Gateways and 1 Elastic IP (EIP) addresses

- Now use similar approach to create the NAT Gateways in a new file called natgateway.tf.

Note: We need to create an Elastic IP for the NAT Gateway, and you can see the use of depends_on to indicate that the Internet Gateway resource must be available before this should be created. Although Terraform does a good job to manage dependencies, but in some cases, it is good to be explicit.

**AWS ROUTES**

Create a file called route_tables.tf and use it to create routes for both public and private subnets, create the below resources. Ensure they are properly tagged.

- aws_route_table
- aws_route
- aws_route_table_association

Now if you run terraform plan and terraform apply it will add the following resources to AWS in multi-az set up:

– Our main vpc
– 2 Public subnets
– 4 Private subnets
– 1 Internet Gateway
– 1 NAT Gateway
– 1 EIP
– 2 Route tables

**AWS Identity and Access Management**

IaM and Roles
We want to pass an IAM role our EC2 instances to give them access to some specific resources, so we need to do the following:

1. Create AssumeRole
Assume Role uses Security Token Service (STS) API that returns a set of temporary security credentials that you can use to access AWS resources that you might not normally have access to. These temporary credentials consist of an access key ID, a secret access key, and a security token. Typically, you use AssumeRole within your account or for cross-account access.

Add the following code to a new file named roles.tf

In this code we are creating AssumeRole with AssumeRole policy. It grants to an entity, in our case it is an EC2, permissions to assume the role.

2. Create IAM policy for this role

This is where we need to define a required policy (i.e., permissions) according to our requirements. For example, allowing an IAM role to perform action describe applied to EC2 instances:

3. Attach the Policy to the IAM Role
This is where, we will be attaching the policy which we created above, to the role we created in the first step.

4. Create an Instance Profile and interpolate the IAM Role

**CREATE SECURITY GROUPS**

We are going to create all the security groups in a single file, then we are going to refrence this security group within each resources that needs it.

IMPORTANT:

Check out the terraform documentation for 	[security group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

Check out the terraform documentation for 	[security group rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)

Create a file and name it security.tf, copy and paste the code below

**CREATE CERTIFICATE FROM AMAZON CERIFICATE MANAGER**

Create cert.tf file and add the following code snippets to it.

NOTE: Read Through to change the domain name to your own domain name and every other name that needs to be changed.

**Create an external (Internet facing) Application Load Balancer (ALB)**

- Create a file called alb.tf
- First of all we will create the ALB, then we create the target group and lastly we will create the lsitener rule.

Useful Terraform Documentation, go through this documentation and understand the arguement needed for each resources:

[ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
[ALB-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)
[ALB-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)


- We need to create an ALB to balance the traffic between the Instances:

- To inform our ALB to where route the traffic we need to create a Target Group to point to its targets:

- Then we will need to create a Listner for this target Group

- Add the following outputs to output.tf to print them on screen

**Create an Internal (Internal) Application Load Balancer (ALB)**

- For the Internal Load balancer we will follow the same concepts with the external load balancer.

- Add the code snippets inside the alb.tf file
- To inform our ALB to where route the traffic we need to create a Target Group to point to its targets:

- Then we will need to create a Listner for this target Group

**CREATING AUSTOSCALING GROUPS**

Now we need to configure our ASG to be able to scale the EC2s out and in depending on the application traffic.

Before we start configuring an ASG, we need to create the launch template and the the AMI needed. For now we are going to use a random AMI from AWS, then in project 19, we will use Packerto create our ami.

Based on our Architetcture we need for Auto Scaling Groups for bastion, nginx, wordpress and tooling, so we will create two files; asg-bastion-nginx.tf will contain Launch Template and Austoscaling froup for Bastion and Nginx, then asg-wordpress-tooling.tf will contain Launch Template and Austoscaling group for wordpress and tooling.

Useful Terraform Documentation, go through this documentation and understand the arguement needed for each resources:

[SNS-topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)
[SNS-notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification)
[Austoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
[Launch-template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)


- Create asg-bastion-nginx.tf and paste all the codes given in the docs
- creating notification for all the auto scaling groups

**launch template for bastion**

- Autoscaling for wordpres and tooling will be created in a seperate file

- Create asg-wordpress-tooling.tf and paste the following code

**STORAGE AND DATABASE**

Useful Terraform Documentation, go through this documentation and understand the arguement needed for each resources:

[RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)
[EFS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)
[KMS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)

**Create Elastic File System (EFS)**

In order to create an EFS you need to create a KMS key.

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications.

- Add the following code  on docs to efs.tf
- Let us create EFS and it mount targets- add the following code to efs.tf

**Create MySQL RDS**

- Let us create the RDS itself using this snippet of code in rds.tf file:

- Before Applying, if you take note, we gave refrence to a lot of varibales in our resources that has not been declared in the variables.tf file. Go through the entire code and spot this variables and declare them in the variables.tf file.

- Now, we are almost done but we need to update the last file which is terraform.tfvars file. In this file we are going to declare the values for the variables in our varibales.tf file.

- Open the terraform.tfvars file and add the code

At this point, you shall have pretty much all infrastructure elements ready to be deployed automatically, but before we paln and apply our code we need to take note of two things;

we have a long list of files which may looks confusing but that is not bad for a start, we are going to fix this using the concepts of modules in Project 18
Secondly, our application wont work becuase in out shell script that was passed into the launch some endpoints like the RDs and EFS point is needed in which they have not been created yet. So in project 19 we will use our Ansible knowledge to fix this.

DEFINITION OF NETWORKING CONCEPTS

- IP Address : IP address stands for “Internet Protocol address.” The Internet Protocol is a set of rules for communication over the internet, such as sending mail, streaming video, or connecting to a website. An IP address identifies a network or device on the internet

- Subnets : A subnetwork or subnet is a logical subdivision of an IP network.The practice of dividing a network into two or more networks is called subnetting.

- CIDR Notation : Classless inter-domain routing (CIDR) is a set of Internet Protocol (IP) standards that is used to create unique identifiers for networks and individual devices. The IP addresses allow particular information packets to be sent to specific computers. Shortly after the introduction of CIDR, technicians found it difficult to track and label IP addresses, so a notation system was developed to make the process more efficient and standardized. 


- IP Routing : IP Routing is an umbrella term for the set of protocols that determine the path that data follows in order to travel across multiple networks from its source to its destination. Data is routed from its source to its destination through a series of routers, and across multiple networks.

- Internet Gateways: Internet Gateway means a network connection that acts as the focal points for internal and external access to a particular network or subnet.

- NAT Gateway : A NAT gateway is a Network Address Translation (NAT) service. You can use a NAT gateway so that instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.
  
- OSI MODEL : The Open Systems Interconnection (OSI) model describes seven layers that computer systems use to communicate over a network. It was the first standard model for network communications, adopted by all major computer and telecommunication companies in the early 1980s

- TCP/IP SUITE : TCP/IP specifies how data is exchanged over the internet by providing end-to-end communications that identify how it should be broken into packets, addressed, transmitted, routed and received at the destination. TCP/IP requires little central management and is designed to make networks reliable with the ability to recover automatically from the failure of any device on the network.

The two main protocols in the IP suite serve specific functions. TCP defines how applications can create channels of communication across a network. It also manages how a message is assembled into smaller packets before they are then transmitted over the internet and reassembled in the right order at the destination address.

IP defines how to address and route each packet to make sure it reaches the right destination. Each gateway computer on the network checks this IP address to determine where to forward the message.

OSI VS TCP/IP : 

- TCP/IP is a functional model designed to solve specific communication problems, and which is based on specific, standard protocols. OSI is a generic, protocol-independent model intended to describe all forms of network communication.
- In TCP/IP, most applications use all the layers, while in OSI simple applications do not use all seven layers. Only layers 1, 2 and 3 are mandatory to enable any data communication.

ASSUME ROLE POLICY VS ROLE POLICY

AssumeRole policy is a trust policy attached with the IAM role to allow the IAM user to access the AWS resource using the temporary security credentials. The policy specifies the AWS resource that the IAM user can access and the actions that the IAM user can perform. 
While Role policy is an IAM identity that you can create in your account that has specific permissions. An IAM role is similar to an IAM user, in that it is an AWS identity with permission policies that determine what the identity can and cannot do in AWS. However, instead of being uniquely associated with one person, a role is intended to be assumable by anyone who needs it. Also, a role does not have standard long-term credentials such as a password or access keys associated with it. Instead, when you assume a role, it provides you with temporary security credentials for your role session.


























--------------------------------------------------
install graphviz
sudo apt install graphviz

use the command below to generate dependency graph
`terraform graph -type=plan | dot -Tpng > graph.png`
`terraform graph | dot -Tpng > graph.png`
Read More abot terrafrom graph
https://www.terraform.io/docs/cli/commands/graph.html