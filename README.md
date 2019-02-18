# Terraform Project
This is a [terraform](https://www.terraform.io/) project for [darkmatter.cloud](https://darkmatter.cloud)

## Pre-requisites
There are several things that you will need to get started:
* Create an [AWS Account](https://aws.amazon.com)
* Create an [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) w/API Access Keys
* Configure your [AWS Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* Create an S3 Bucket to store your [Terraform Remote State](https://www.terraform.io/docs/state/remote.html)
* Install a Programmer Text Editor or IDE w/ Terraform Support (syntax highlighting, formatting, etc)
    * [Atom](https://atom.io/)
    * [VS Code](https://visualstudio.microsoft.com/)
* Install the [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
* Install the [Terraform](https://www.terraform.io/downloads.html) Binary 
* Install [git](https://git-scm.com/downloads)
* Create git repository
    * [BitBucket](https://bitbucket.org)
    * [Github](https://github.com)
    * [Gitlab](https://about.gitlab.com/)

## Project Setup

### Install Terraform

(Install Terraform)[https://learn.hashicorp.com/terraform/getting-started/install.html]

* To install Terraform, find the appropriate package for your system and download it. 
* Terraform is packaged as a zip archive.
* After downloading Terraform, unzip the package. 
* Terraform runs as a single binary named terraform. 
* The final step is to make sure that the `terraform` binary is available on the `PATH`.

    # Create .terraform Directory 
    mkdir ~/.terraform

    # Follow Install Instructions
      - Download Terraform Package
      - Unzip the Package
      - Add .terraform Directory to PATH

    # Verify Terraform Version
    terraform --version
    Terraform v0.11.10

### Programmer Text Editor w/Terraform Language Support

    # Install a Programmer Text Editor  (e.g. VS Code)

    # Configure Terraform Support
    # https://marketplace.visualstudio.com/items?itemName=mauve.terraform]

### AWS CLI Configuration

(AWS Command Line Interface)[https://aws.amazon.com/cli/]

    # Install AWS Command Line Interface

    # Create AWS Configuration Directory
    mkdir ~/.aws
    
    # Create File .aws/config
    [profile default]
    output = json
    region = us-east-1

    # Create File .aws/credentials
    [default]
    aws_access_key_id = <your_aws_access_key_id>
    aws_secret_access_key = <your_aws_secret_access_key>
    output = json
    region = us-east-1
    s3 =
        signature_version = s3v4

    # SET AWS Environment Variable in your .bash_profile or .bashrc
    AWS_PROFILE=default


## Create S3 Bucket (private) to store Terraform Remote State in S3

    # Use AWS Console or Command Line Interface
    # Keep this Bucket and all Objects Private
    # Verify S3 Bucket and AWS Credentials 
    aws s3 ls
    2019-01-01 00:00:00 <your_terraform_bucket>



## Create Environment using vpc-environment module

### Create Demo Workspace

    # Create Demo Workspace Directory
    mkdir workspaces/
    mkdir workspaces/demo

### Create Environment Stack 

    # Create Environment Stack Directory
    mkdir workspaces/demo/environment
    cd workspaces/demo/environment

    # Create backend.tf to configure remote S3 backend
    
    # Create main.tf to deploy module vpc-environment sourced locally

    # See examples in module

### List Terraform Workspaces

    terraform workspace list
    * default

### Create New Terraform Workspace 'demo'
    terraform workspace new demo
    Created and switched to workspace "demo"!

    You're now on a new, empty workspace. Workspaces isolate their state,
    so if you run "terraform plan" Terraform will not see any existing state
    for this configuration.

### Verify Workspace
    
    terraform workspace list
    default
    * demo

### Run Terraform Init
Run Terraform Init to initialize the terraform backend and modules

    cd workspaces/demo/environment/
    terraform init

    * provider.aws: version = "~> 1.59"
    * provider.local: version = "~> 1.1"
    * provider.random: version = "~> 2.0"
    * provider.template: version = "~> 2.0"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.

### Run Terraform Plan
Run Terraform Plan to review the resources that will be provisioned in the demo environment:
   
    cd /workspaces/demo/environment/
    terraform plan
    ...
    Plan: 42 to add, 0 to change, 0 to destroy.


### Run Terraform Apply
Run Terraform Apply to review and provision the new demo environment:

    cd /workspaces/demo/environment/
    terraform apply
    ...
    Plan: 42 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions in workspace "demo"?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes [Enter]
    ...

    # Quite a few resources.  
    # Again, this is bootstrapping an entire vpc-environment
    # Success!

    Apply complete! Resources: 42 added, 0 changed, 0 destroyed.

### Verify via Terraform Plan
Verify the state via terraform plan:

    cd /workspaces/demo/environment/
    terraform plan

    # We now see 2 to change, this is because the Security Groups (Public/Private) 
    # are calculating rules based on variables we're passing the module
    Plan: 0 to add, 2 to change, 0 to destroy.

### Run Terraform Destroy
Once you are done working, simply destroy the environment:

    cd /workspaces/demo/environment/
    terraform destroy

    Destroy complete! Resources: 42 destroyed.

## SUCCESS!
Congratulations!!! 
You now have a working demo environment in AWS that you can spin up an down to develop, test, and demo new solutions.

## NEXT STEPS >
From here you can layer on additional stacks such as needed. See the local modules directory to get started.