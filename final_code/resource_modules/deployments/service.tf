# Resource: MySQL Cluster IP Service
resource "kubernetes_service_v1" "mysql_clusterip_service" {
  metadata {
    name = "mysql"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.mysql_deployment.spec.0.selector.0.match_labels.app 
    }
    port {
      port        = 3306 # Service Port
      #target_port = 3306 # Container Port  # Ignored when we use cluster_ip = "None"
    }
    type = "ClusterIP"
    cluster_ip = "None" # This means we are going to use Pod IP   
  }
}

# Resource: Kubernetes Service Manifest (Type: Load Balancer - Network)
resource "kubernetes_service_v1" "application_lb_service" {
  metadata {
    name = "usermgmt-webapp-application-lb-service"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "alb"    # To create Network Load Balancer
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.usermgmt_webapp.spec.0.selector.0.match_labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}