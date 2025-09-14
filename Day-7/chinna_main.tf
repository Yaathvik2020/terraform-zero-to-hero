provider "aws" {
  region="ap-south-1"
}

provider "vault" {
  address = "http://13.233.179.127:8200"
  skip_child_token = true
  
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "0c9e0a83-a282-9f71-34ff-d30796460460"
      secret_id = "203129f0-8dd7-4177-a1b7-3c2321ad2721"
    }
  }
}
resource "vault_mount" "kvv2" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "example" {
  mount               = vault_mount.kvv2.path
  name                = "test_secret"
  delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
      username ="yaathvik"
    }
  )
}

data "vault_kv_secret_v2" "example" {
  mount = vault_mount.kvv2.path
  name  = vault_kv_secret_v2.example.name
}

resource "aws_instance" "my_instance" {
  ami           = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["foo"]
  }
}
resource "aws_s3_bucket" "i" {
  bucket = "test-bucket-yaathvik-12345"
  tags = {
    Name = "test-bucket"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
