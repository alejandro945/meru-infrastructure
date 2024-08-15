module "networks" {
  source = "./modules/network"
  project              = var.project_name
  cidr_block           = var.cird_block_vpc
  az_list              = var.az_list
  public_subnet_cidrs  = var.public_subnet_cidrs  
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "meru-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = "vpc-1234556abcdef"
  subnet_ids               = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::123456789012:role/something"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "security_group" {
  for_each = var.instances
  source               = "./modules/security/security-groups"
  security_group_name  = "${each.value.instance_name}-sg"
  vpc_id               = module.nets.vpc_id
  allowed_ssh_cidrs    = var.allowed_ssh_cidrs
  allowed_http_cidrs   = var.allowed_http_cidrs
  depends_on = [ module.networks ]
}

module "ec2_instance" {
  for_each = var.instances
  source            = "./modules/compute/ec2"
  instance_type     = each.value.instance_type
  instance_name     = each.value.instance_name
  security_group_id = module.security_group[each.key].security_group_id
  ami_id            = var.ami_id
  key_name          = var.key_name
  subnet_id         = module.networks.public_nets[0]
  user_data         = file("${path.module}/utils/main.sh")
  depends_on = [ module.security_group ]
}

resource "aws_key_pair" "tf_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

