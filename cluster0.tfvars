app_instance_type = "t2.small"

db_password = ""
ssh_public_key = ""
ssh_private_key = ""

cluster_name = "mattermost"
db_instance_type = "db.t2"

region="us-west-2"
ami="ami-0375ca3842950ade6"

provider "aws" {
    region = "us-east-2"
    profile = ""
}
