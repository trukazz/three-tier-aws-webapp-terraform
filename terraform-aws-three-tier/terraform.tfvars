vpc_cidr = "10.0.0.0/16"
vpc_name = "main-vpc"



subnets = {
  public1 = {
    cidr_block = "10.0.1.0/24"
    az         = "eu-west-2a"
    public     = true

  }

  public2 = {
    cidr_block = "10.0.2.0/24"
    az         = "eu-west-2b"
    public     = true
  }

  public3 = {
    cidr_block = "10.0.3.0/24"
    az         = "eu-west-2c"
    public     = true
  }

  private1 = {
    cidr_block = "10.0.4.0/24"
    az         = "eu-west-2a"
    public     = false
  }

  private2 = {
    cidr_block = "10.0.5.0/24"
    az         = "eu-west-2b"
    public     = false
  }
  private3 = {
    cidr_block = "10.0.6.0/24"
    az         = "eu-west-2c"
    public     = false
  }
}
