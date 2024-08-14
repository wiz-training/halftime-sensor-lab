resource "random_string" "uid" {
  length  = 8
  special = false
  upper   = false
}


# Customer Information Bucket 
# resource "aws_s3_bucket" "customer_info" {
#   bucket        = "customer-info-${random_string.uid.result}"
#   force_destroy = true
# }

# resource "aws_s3_object" "customer_info_file_upload" {
#   bucket = aws_s3_bucket.customer_info.id

#   for_each = fileset("${path.module}/staging/customer_info/", "*")

#   key          = each.value
#   source       = "${path.module}/staging/customer_info/${each.value}"
#   content_type = each.value
# }

# Web App Static Files Bucket
resource "aws_s3_bucket" "web_images" {
  bucket        = "web-app-static-files-${random_string.uid.result}"
  force_destroy = true
}

resource "aws_s3_object" "web_images_file_upload" {
  bucket = aws_s3_bucket.web_images.id

  for_each = fileset("${path.module}/staging/web_images/", "*")

  key          = each.value
  source       = "${path.module}/staging/web_images/${each.value}"
  content_type = each.value
}
