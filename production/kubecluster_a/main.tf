locals {
  name               = "kubecluster-a"
  project            = "${var.service_project}"
  networking_project = "${var.networking_project}"
  network            = "${data.terraform_remote_state.networking.outputs["network_a"]}"
  subnetwork         = "${data.terraform_remote_state.networking.outputs["subnet_a1"]}"
  subnetwork_name    = "${data.terraform_remote_state.networking.outputs["subnet_a1_name"]}"
  cluster_range      = "${data.terraform_remote_state.networking.outputs["subnet_a1_pod_ip_cidr_range_name"]}"
  services_range     = "${data.terraform_remote_state.networking.outputs["subnet_a1_srv_ip_cidr_range_name"]}"
  region             = "${data.terraform_remote_state.networking.outputs["subnet_a1_region"]}"
  zone1              = "${data.terraform_remote_state.networking.outputs["subnet_a1_zone1"]}"
  zone2              = "${data.terraform_remote_state.networking.outputs["subnet_a1_zone2"]}"
  node_locations     = ["${local.zone1}", "${local.zone2}"]
}

module "kubecluster_a" {
  source         = "github.com/runonautomation/gke-private"
  name           = "${local.name}"
  network        = "${local.network}"
  subnetwork     = "${local.subnetwork}"
  project        = "${local.project}"
  location       = "${local.region}"
  node_locations = "${local.node_locations}"
  cluster_range  = "${local.cluster_range}"
  services_range = "${local.services_range}"
}

# Required for load balancer access of external clients
resource "google_compute_firewall" "allow_http_world" {
  name    = "allow-http-world"
  network = "${local.network}"
  project = "${local.networking_project}"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Required for ingress health checks to communicate with the node ports
resource "google_compute_firewall" "allow_ingress_loadbalanders" {
  name    = "allow-ingress-loadbalancers"
  network = "${local.network}"
  project = "${local.networking_project}"
  allow {
    protocol = "tcp"
    ports    = ["30000-33000"]
  }
  source_ranges = ["130.211.0.0/22","209.85.152.0/22","209.85.204.0/22","35.191.0.0/16"]
}