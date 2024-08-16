################################
#            NETWORK           #
################################

module "networks" {
  source = "./modules/network"
  project              = var.project_name
  cidr_block           = var.cird_block_vpc
  az_list              = var.az_list
  public_subnet_cidrs  = var.public_subnet_cidrs  
  private_subnet_cidrs = var.private_subnet_cidrs
}

################################
#            CLUSTER           #
################################

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
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
    kube-proxy             = {
      most_recent = true
    }
    vpc-cni                = {
      most_recent              = true 
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = module.networks.vpc_id
  subnet_ids               = module.networks.private_nets
  control_plane_subnet_ids = module.networks.private_nets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    stw_node_wg = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}

################################
#         EC2 BASTION          #
################################

module "security_group" {
  for_each = var.instances
  source               = "./modules/security/security-groups"
  security_group_name  = "${each.value.name}-sg"
  vpc_id               = module.networks.vpc_id
  allowed_ssh_cidrs    = var.allowed_ssh_cidrs
  allowed_http_cidrs   = var.allowed_http_cidrs
  depends_on = [ module.networks ]
}

module "ec2_instance" {
  for_each = var.instances
  source            = "./modules/compute/ec2"
  instance_type     = each.value.instance_type
  instance_name     = each.value.name
  security_group_id = module.security_group[each.key].security_group_id
  ami_id            = var.ami_id
  key_name          = aws_key_pair.tf_key.key_name
  subnet_id         = module.networks.public_nets[0]
  user_data         = file("${path.module}/utils/main.sh")
  depends_on = [ module.security_group ]
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.file_name
}

