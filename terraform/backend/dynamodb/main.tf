
resource "aws_dynamodb_table" "terraform-lock" {
    name           = var.tableName
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}

