terraform {
  backend "s3" {
    bucket = "myazterrabucket"
    key = "Terra-Project"
    region = "ap-south-1"
    dynamodb_table = "my-dynamodb-table"
  }
}
