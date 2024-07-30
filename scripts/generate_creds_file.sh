echo "[default]" > ../src/credentials
echo "aws_access_key_id = $(terraform -chdir=../terraform/ output -raw access_key_id)" >> ../src/credentials
echo "aws_secret_access_key = $(terraform -chdir=../terraform/ output -raw secret_access_key)" >> ../src/credentials
