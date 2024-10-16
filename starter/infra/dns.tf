# locals {
#   ingress_hostname = length(kubernetes_service.blue.status[0].load_balancer[0].ingress) > 0 ? kubernetes_service.blue.status[0].load_balancer[0].ingress[0].hostname : "default.example.com"
# }
# resource "aws_route53_record" "blue" {
#   zone_id = aws_route53_zone.private_dns.id
#   name    = "blue-green.udacityproject.com"
#   type    = "CNAME"
#   ttl     = 5

#   weighted_routing_policy {
#     weight = 2
#   }

#   set_identifier = "blue"
#   records        = [local.ingress_hostname]
#   # https://github.com/hashicorp/terraform-provider-kubernetes/pull/1125
#}


 locals {
   ingress_hostname = length(kubernetes_service.green.status[0].load_balancer[0].ingress) > 0 ? kubernetes_service.green.status[0].load_balancer[0].ingress[0].hostname : "default.example.com"
 }
 resource "aws_route53_record" "green" {
   zone_id = aws_route53_zone.private_dns.id
   name    = "blue-green"
   type    = "CNAME"
   ttl     = 5

   weighted_routing_policy {
     weight = 2
   }

   set_identifier = "green"
   records        = [local.ingress_hostname]
   # https://github.com/hashicorp/terraform-provider-kubernetes/pull/1125
 }

 resource "aws_route53_zone" "private_dns" {  # Correctly place the vpc block inside aws_route53_zone resource
   name    = "udacityproject"
   comment = "DNS for Udacity Projects"
  
   vpc {
     vpc_id = module.vpc.vpc_id
   }
 }


