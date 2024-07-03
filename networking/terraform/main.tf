/*
VPC: 10.0.0.0/8
subnet1: us-east1: 10.120.0.0/20 //bastion host, load balancer
subnet2: us-central1: 10.121.0.0/20 //web app VMs
subnet3: us-west1: 10.122.0.0/20 //database
*/
data "google_compute_network" "default_vpc" { //has been updated to custom-mode
  name = "default"
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "10.120.0.0/20" 
  region        = "us-east1" 
  network       = google_compute_network.default_vpc.id
}

resource "google_compute_subnetwork" "private1" {
  name          = "private1"
  ip_cidr_range = "10.121.0.0/20" 
  region        = "us-central1" 
  network       = google_compute_network.default_vpc.id
}

resource "google_compute_subnetwork" "private2" {
  name          = "private2"
  ip_cidr_range = "10.122.0.0/20" 
  region        = "us-west1" 
  network       = google_compute_network.default_vpc.id
}


//CREATE MANAGED INSTANCE GROUP 
//VMS
//bastion host: publically available
//static external IP + ephemeral internal IP
//gcloud compute ssh VM_NAME --internal-ip: to connect from a bastion host  
resource "google_compute_address" "bastion_static" {
  name = "ipv4-address"
} 
resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n2-standard-2"
  # tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public
    access_config {
      nat_ip = google_compute_address.bastion_static.address
    }
  }
  # metadata = {
  #   foo = "bar"
  # }
} //TODO: put logging here 

//ephemeral internal IP ONLY (so it is in a complete private subnet, meaning you cannot ssh or anything unless through bastion) 
//TODO: create for loop to create 2 
resource "google_compute_instance" "web_server1" {
  name         = "web_server1"
  machine_type = "n2-standard-2"
  # tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private1
  }

  # metadata = {
  #   foo = "bar"
  # }
}

//ROUTES 

//default route (0.0.0.0/0) automatically created to allow internet traffic through default internet gateway
//practice routes through load balacning? 