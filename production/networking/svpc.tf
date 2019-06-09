resource "google_project_service" "host_project_compute_api" {
  project            = "${var.networking_project}"
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "host_project_container_api" {
  project            = "${var.networking_project}"
  service            = "container.googleapis.com"
  disable_on_destroy = false
  depends_on         = ["google_project_service.host_project_container_api"]
}

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project    = "${var.networking_project}"
  depends_on = ["google_project_service.host_project_container_api"]
}