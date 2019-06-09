
##
# Setting service project
##

resource "google_project_service" "service_project_compute_api" {
  project            = "${local.project}"
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "service_project_container_api" {
  project            = "${local.project}"
  service            = "container.googleapis.com"
  disable_on_destroy = false
  depends_on         = ["google_project_service.service_project_compute_api"]
}

resource "google_compute_shared_vpc_service_project" "shared_vpc_service" {
  host_project    = "${var.networking_project}"
  service_project = "${local.project}"
  depends_on      = ["google_project_service.service_project_compute_api"]
}



##
# Defining required permissions
##
data "google_project" "service" {
  project_id = "${local.project}"
}

resource "google_project_iam_member" "host_service_agent_user" {
  project    = "${var.networking_project}"
  role       = "roles/container.hostServiceAgentUser"
  member     = "serviceAccount:service-${data.google_project.service.number}@container-engine-robot.iam.gserviceaccount.com"
  depends_on = ["google_project_service.service_project_container_api"]
}

resource "google_compute_subnetwork_iam_member" "cloudservices_network_user" {
  project    = "${var.networking_project}"
  subnetwork = "${local.subnetwork_name}"
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${data.google_project.service.number}@cloudservices.gserviceaccount.com"
  depends_on = ["google_project_service.service_project_container_api"]
  region     = "${local.region}"
}

resource "google_compute_subnetwork_iam_member" "container_network_user" {
  project    = "${var.networking_project}"
  subnetwork = "${local.subnetwork_name}"
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${data.google_project.service.number}@container-engine-robot.iam.gserviceaccount.com"
  depends_on = ["google_project_service.service_project_container_api"]
  region     = "${local.region}"
}
