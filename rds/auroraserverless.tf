variable "cluster_name" {}
variable "db_password" {}
variable "vpc_security_group_ids" { type = list }
variable "availability_zones" { type = list }

resource "aws_rds_cluster" "db_cluster" {
    cluster_identifier = "${var.cluster_name}-db"
    database_name = "mattermost"
    master_username = "mmuser"
    master_password = "${var.db_password}"
    skip_final_snapshot = true
    engine = "aurora"
    engine_version = "5.6.10a"
    engine_mode = "serverless"
    apply_immediately = true
    vpc_security_group_ids = var.vpc_security_group_ids
    availability_zones = var.availability_zones
    scaling_configuration {
        auto_pause               = true
        max_capacity             = 4
        min_capacity             = 1
        seconds_until_auto_pause = 300
    }
}

output "dbEndpoint" {
    value = "${aws_rds_cluster.db_cluster.endpoint}"
}

output "dbReaderEndpoint" {
    value = "${aws_rds_cluster.db_cluster.reader_endpoint}"
}

