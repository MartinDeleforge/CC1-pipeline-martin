# Create a S3 bucket - destination of the data pipeline
resource "aws_s3_bucket" "summary_destination" {
  bucket = "summary-destination-episen3-ds1-mdlg"
  acl    = "private"

  tags = {
    Name        = "S3 bucket"
    Environment = "test"
  }
}
