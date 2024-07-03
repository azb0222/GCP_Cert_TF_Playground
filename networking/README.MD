# NOTES: 

**Steps**
1) `gcloud projects create <project-id>` 
2) `gcloud compute networks update default --switch-to-custom-subnet-mode`
3) 
```
for region in $(gcloud compute regions list --format="value(name)"); do 
  gcloud compute networks subnets delete default --region=$region --quiet
done 
```
4) `terraform init`
5) `terraform apply`




# DESCRIPTION 
## Scenario 1: Networking
<TODO>: Create Architecture diagram 
**Highly Available Web Application** 
- custom VPC w/ public + private subnets
  - public: bastion + load balancer 
  - private: web servers + databases
    - VPC peering necessary? 
  - include a secondary IP range in one of them
- firewall rules, routes, forwarding rules 
- bastion host for secure internal access 
- global load balancer to distribute traffic across VMs deployed across regions 
- logging + monitoring tools  
- caching 
- certificates and DNS 
- tags

- use an alias IP range for one of the VMs to run sample k8 on two VMs 

### Project Description: Highly Available Web Application with Enhanced Networking and Security on GCP

#### Objective
Create a highly available web application infrastructure on Google Cloud Platform (GCP) that incorporates advanced networking, security, and monitoring components. The project will include a VPC network with private and public subnets, a bastion host for secure access, a global load balancer, multiple VM instances across regions, managed databases, and various security and monitoring tools.

#### Components and Requirements

1. **VPC Network**
   - Create a custom VPC with multiple subnets:
     - Public subnets for the load balancer and bastion host.
     - Private subnets for web servers and databases.
   - Implement VPC peering if instances are across multiple regions.

2. **Firewall Rules**
   - Define firewall rules to:
     - Allow SSH access to the bastion host from specific IP addresses.
     - Allow HTTP/HTTPS traffic to the load balancer.
     - Allow internal communication between subnets.
     - Restrict access to databases and internal resources.

3. **Bastion Host**
   - Set up a bastion host in a public subnet with an external IP address.
   - Configure SSH access to internal instances only via the bastion host.

4. **VM Instances**
   - Deploy web server instances in private subnets across different regions for high availability.
   - Ensure instances do not have external IPs and are only accessible internally.

5. **Global Load Balancer**
   - Set up a global HTTP(S) load balancer to distribute traffic across the web servers.
   - Configure health checks to monitor the status of web servers.
   - Use Cloud Armor to protect against common web attacks.

6. **Managed Database**
   - Deploy a managed database instance (e.g., Cloud SQL) in a private subnet.
   - Configure private IP access to the database.
   - Ensure secure and restricted access to the database.

7. **Cloud NAT**
   - Implement Cloud NAT to allow instances in private subnets to access the internet for updates without having external IPs.

8. **Monitoring and Logging**
   - Set up Stackdriver Monitoring and Logging to track the performance and security of the application.
   - Configure alerts for critical metrics and logs.

9. **Auto-scaling**
   - Implement auto-scaling policies for VM instances to handle variable traffic loads.

10. **Content Delivery Network (CDN)**
    - Integrate Cloud CDN to cache content and reduce latency for users across different regions.

11. **Security Enhancements**
    - Use IAM roles and service accounts to control access to resources and APIs.
    - Implement least privilege principles for all accounts and services.
    - Establish a secure connection between your on-premises network and GCP using VPN or Dedicated Interconnect if necessary.
    - Use managed SSL/TLS certificates for secure communication.

### Architecture Diagram
1. **Bastion Host**:
   - Located in a public subnet with an external IP.
   - Allows SSH access only from specific IPs.

2. **Public Subnet**:
   - Contains the load balancer and Cloud NAT.
   - Load balancer configured with global forwarding rules and health checks.

3. **Private Subnets**:
   - Host web server instances without external IPs.
   - Internal firewall rules to allow traffic only from the load balancer.

4. **Database Subnet**:
   - Contains the managed database instance (Cloud SQL) with a private IP.

5. **Cloud NAT**:
   - Provides outgoing internet access for instances in private subnets for updates.

### Steps to Implement

1. **Set Up VPC Network and Subnets**
   - Create a custom VPC with the required public and private subnets.
   - Implement VPC peering if needed.

2. **Configure Firewall Rules**
   - Define and apply the necessary firewall rules to secure the network.

3. **Deploy the Bastion Host**
   - Set up the bastion host in a public subnet and configure SSH access.

4. **Launch VM Instances**
   - Deploy web server instances in private subnets across different regions.

5. **Configure the Global Load Balancer**
   - Set up the load balancer with health checks and backend services.

6. **Set Up Managed Database**
   - Deploy Cloud SQL in a private subnet with private IP access.

7. **Implement Cloud NAT**
   - Configure Cloud NAT to allow internet access for private instances.

8. **Set Up Monitoring and Logging**
   - Enable Stackdriver Monitoring and Logging for the infrastructure.

9. **Configure Auto-scaling**
   - Implement auto-scaling policies for web server instances.

10. **Integrate CDN**
    - Set up Cloud CDN to cache and serve content globally.

11. **Enhance Security**
    - Apply IAM roles and policies.
    - Set up secure connections and managed SSL/TLS certificates.

### Final Testing and Validation
- **Load Balancer**: Access the load balancer's IP to ensure traffic is distributed correctly.
- **Bastion Host**: Verify secure SSH access to internal instances.
- **Firewall Rules**: Ensure that only allowed traffic reaches the instances.
- **Database Access**: Confirm secure and restricted access to the managed database.
- **Auto-scaling**: Test the auto-scaling functionality under load.
- **Monitoring and Alerts**: Check that monitoring and alerts are functioning correctly.

This comprehensive project will give you hands-on experience with GCP networking, security, and operational best practices, helping you understand how various components interact in a real-world scenario.