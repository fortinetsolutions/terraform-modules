# LAB 1 - Create FortiGate test environment manually in GCP Console

<details>
    
* Network Diagram

    ![diagram1](https://github.com/fortidg/markdown-test/blob/main/images/network-diagram.png)

***

## Chapter 1 - Setting up the environment

***[Deployment exercise - estimated duration 45min]***

<details>

<summary>In this step we will create the required VPC Networks and security rules needed.  We will also create the FortiGate and Ubuntu server.</summary>

### Task 1 - Log into your GCP Console

* Login by scrolling down to the Google Console Details section.  Make note of the Password and click **Fleet Console**

    ![console1](https://github.com/fortidg/markdown-test/blob/main/images/qwiklabs-info-page1.png)

* This will take you to your sign in page and pre-populate the User Account information.  Click **Next**

    ![console2](https://github.com/fortidg/markdown-test/blob/main/images/console-login-1.png)

* Input the previously noted password

    ![console3](https://github.com/fortidg/markdown-test/blob/main/images/console-login-2.png)

* Accept all popups and warnings.  You are now at your Console Home screen.  Not the Pinned products down the left side of the screen.

    ![console4](https://github.com/fortidg/markdown-test/blob/main/images/console-home.png)

### Task 2 - Create VPC Networks

#### Tidbit - The GCP approach to VPC Networks is a bit different than other Vendors.  For example: In AWS, a VPC is a collection of Subnets.  VM instances completely reside within a VPC and have NICs in multiple subnets.  By Contrast, in GCP an instance can only have one vNIC within a VPC Network.  These VPC Networks can be divided into Subnets, but a Virtual Machine can only have a vNIC in one of them.  This means that in order to create a standard Untrust/Trust architecture in GCP, you need two separate VPC Networks.

* On the left pane, click on **VPC network**

    ![console5](https://github.com/fortidg/markdown-test/blob/main/images/VPC-Network-left-pane.png)

* At the top of the screen, click on **CREATE "untrust" VPC NETWORK**

* Input all fields as directed below.
  
  **Any Value not listed below will be left as default.**

1. For "Name" use "untrust"
1. For "Subnet Creation Mode", **Custom** is selected.
1. Under **New Subnet** name the subnet "untrust-1" and select **us-central1** region from Dropdown
1. Under **New Subnet** type "192.168.128.0/25" and select **Done**.
    ![console6](https://github.com/fortidg/markdown-test/blob/main/images/untrust-1-subnet.png)
1. Under **Firewall Rules** select **untrust-allow-custom** and click on **EDIT** to the right of the rule.
1. This will cause a pop up.  
1. Un-check **Use subnets' IPv4 ranges** and type "0.0.0.0/0" under other IPv4 Ranges.
    ![console7](https://github.com/fortidg/markdown-test/blob/main/images/untrust-allow.png)
1. Click **CONFIRM**
1. Click **CREATE**

* Repeat the process to create a second VPC Network named "trust" and with a subnet CIDR of "192.168.129.0/25".

#### Tidbit - Normally we would recommend for Customers to lock down their ingress Firewall rules to only allow the Sources and Ports necessary.  In our lab excercise, we left everything open here, just to make things easier.

### Task 3 - Create FortiGate VM

* At the top left of the screen click the Hamburger menu then Select **Compute Engine** > **VM instances**.
    ![console8](https://github.com/fortidg/markdown-test/blob/main/images/compute-engine.png)

* Click **CREATE INSTANCE**

  **Any Value not listed below will be left as default.**

1. On the left side of the screen, click **Marketplace**
1. In the pop up, type FortiGate in the search bar and select the **FortiGate Next-Generation Firewall (PAYG)** option.
    ![console9](https://github.com/fortidg/markdown-test/blob/main/images/marketplace.png)
1. In the next pop up, choose **Launch**
    ![console10](https://github.com/fortidg/markdown-test/blob/main/images/launch-fgt.png)
1. Under **Networking** > **Network interfaces** click on the down arrow next to default.
    ![console11](https://github.com/fortidg/markdown-test/blob/main/images/default-fgt-int.png)
1. Configure the Network as follows and Click **Done**.

    ![console12](https://github.com/fortidg/markdown-test/blob/main/images/untrust-nic.png)
1. Under **Networking** > **Network interfaces** click on **ADD NETWORK INTERFACE** and configure as follows.
    ![console13](https://github.com/fortidg/markdown-test/blob/main/images/trust-nic-det.png)
1. At the bottom, check box to accept terms and then click **DEPLOY**.
    ![console14](https://github.com/fortidg/markdown-test/blob/main/images/accept-deploy.png)
1. The **Deployment Manager** screen pops up next.  Make note of the Admin URL and Temporary Admin password.

    ![console15](https://github.com/fortidg/markdown-test/blob/main/images/fortigate-temp-pw.png)

#### Tidbit - We used ephemeral for the Public IP of the FortiGate on the untrust NIC.  This means that the IP address could change when the FortiGate is rebooted.  To avoid this, you can go to **VPC network** > **IP addresses** and **RESERVER EXTERNAL STATIC ADDRESS**

### Task 4 - Create Ubuntu VM

* Go to **Compute Engine** > **VM instances** and click **CREATE INSTANCE**

  **Any Value not listed below will be left as default.**

1. Choose an appropriate name for the VM.
1. Under **Boot disk** select **CHANGE**
1. In the pop up select options as pictured below

    ![console16](https://github.com/fortidg/markdown-test/blob/main/images/ubuntu-image.png)
1. Click the down arrow to expand **Advanced options**.
1. Click the down arrow to expand **Networking**
1. Under **Network interface**, click the down arrow to expand **default** and change the network settings as follows.  Note that  we are **NOT** assigning an External IP address for this instance.

    ![console17](https://github.com/fortidg/markdown-test/blob/main/images/ubuntu-nic.png)
1. Click the down arrow to expand **Management**
1. Under **Automation** paste the below text into the "Startup script" box.
1. Click on **CREATE** at the bottom of the page

```sh
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Wait for Internet access through the FGTs"
while ! curl --connect-timeout 3 "http://www.google.com" &> /dev/null
    do continue
done
apt-get update -y
#install apache2
apt-get install -y apache2
service apache2 restart
/usr/sbin/useradd student1
echo student1:Fortinet1! | chpasswd
usermod -aG sudo student1
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
```

***
</details>

## Chapter 2 - Configure Routing and Firewall

***[Make it work - estimated duration 15min]***

<details>

<summary>In this step we will add routing, and policies to allow traffic from the Ubuntu server to reach the internet through FortiGate, and allow users to access the Apache2 web page on the server from the internet</summary>

### Task 1 - Route Traffic from trust network to the internet through FortiGate

* From the Hamburger Menu go to **Compute Engine** > **VM instances** and click on the previously created FortiGate.  Under the Details screen, copy the Primary internal IP address for nic1 (trust network).

    ![console18](https://github.com/fortidg/markdown-test/blob/main/images/fortigate-interfaces.png)

* From the Hamburger Menu go to **VPC Networks** and click on **trust** in the network list.

* In the center of the screen, click  on **ROUTES** and then click **ADD ROUTE**.

    ![console19](https://github.com/fortidg/markdown-test/blob/main/images/trust-route-add.png)

* Create the default Route to the Fortigate interface

  **Any Value not listed below will be left as default.**

1. Choose an appropriate name.
1. For "Destination IP range" input "0.0.0.0/0".
1. Under "Next hop" select **Specify IP address**
1. Input the fortigate nic1 IP address as "Next hop IP address"
1. Click **CREATE**

    ![console20](https://github.com/fortidg/markdown-test/blob/main/images/default-to-fgt.png)

### Task 2 - Create Policy in FortiGate to allow traffic from trust to untrust

* Log into the FortiGate using the  Admin URL and Temporary Admin password which you noted earlier.  You will be prompted to change the password upon initial login.

* Create a firewall policy allowing all traffic from trust-to-untrust.  If you wait for a few minutes, you should start seeing traffic hitting this policy.  This is the Ubuntu instance updating it's packages and installing apache2.

    ![console21](https://github.com/fortidg/markdown-test/blob/main/images/trust-to-untrust.png)

### Task 3 - Create VIP in FortiGate to allow access to ubuntu server

  **Any Value not listed below will be left as default.**

* Log into the FortiGate and navigate to **Policy & Objects** > ** Virtual IP's

1. Click **Create New** > **Virtual IP**.
1. Choose an appropriate name.
1. Choose **port1** from the dropdown next to **Interface**
1. for **Map to IPv4 address/range** input the IP address of the Ubuntu server you created earlier.  **HINT** - go to **Compute Engine** > **VM instances** to find the ip.
1. Click to toggle **Port Forwarding**
1. For **Protocol** select **TCP**
1. For **Port Mapping Type** select **One to one**
1. For **External service port** use **8080**
1. **Map to IPv4 port** should be set to 80
1. Click **OK** to continue

    ![console22](https://github.com/fortidg/markdown-test/blob/main/images/fortigate-vip-http.png)

* Navigate to **Policy & Objects** > **Fierwall Policy** and create a policy allowing HTTP traffic in to Ubuntu.

    ![console23](https://github.com/fortidg/markdown-test/blob/main/images/vip-in-pol.png)

* In your preferred browser, input **http://<fortigate public ip>:8080** (example http://34.72.196.194:8080).  You should get the default Apache2 landing page.

    ![console24](https://github.com/fortidg/markdown-test/blob/main/images/apache2.png)

#### Tidbit - In this example, we are allowing all IPs inbound and we did not add any security features to our policy.  In a live environment, we would very likely lock this down to specific Source IP addresses as well as add IPS to our policy.  For even better security web servers should be protected by FortiWeb

* **Congratulations!** You have completed the GCP-Basic portion of this training.

***
  </details>

***

## Quiz


### Question 1

* A VM Instance in GCP can have multiple interfaces in the same VPC Network.  (True or False)

<details> 

<summary>Answer</summary>

* **False** - VMs can only have a single interface per VPC Network.

</details>

## Question 2

* By default, External IP Addresses associated with vNICs in GCP are preserved across reboot (True or False)

<details> 

<summary>Answer</summary>

* **False** - By default.  Ephemeral External IP Addresses are assigned to vNICs in GCP.

</details>
    
</details>    
    
***

# LAB 2 - FortiGate: Automating deployment and configuration using Terraform

<details>

## Overview
This lab is intended for network administrators looking to integrate firewall management with DevOps practices and workflow. First part of the lab focuses on deploying a pair of FortiGate virtual appliances using Terraform and bootstrapping their configuration to automatically build a multi-zone HA cluster. Second part deploys a simple web application and leverages fortios terraform provider to include FortiGate configuration changes necessary to protect that application.

All deployments and configuration are driven entirely by terraform code and do not require interactive log-in to FortiGate

### Objectives
In this lab you will:

- Deploy a standard FortiGate HA cluster into Google Cloud using Terraform
- Verify bootstrapping of FortiGate VMs and forming an HA cluster correctly
- Learn how to share data between Terraform deployments
- Deploy a simple web application and reconfigure firewalls to allow traffic to it
- Verify the traffic is passing through the firewall and is protected
- Detect and correct FortiGate configuration drift
- Delete the application and associated firewall configuration

### Architecture
The final architecture and test connection flow is depicted on the diagram below:  
![Architecture overview](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/diag-overview.png)

It is a simplified standard architecture described in [Cloud Architecture Center](https://cloud.google.com/architecture/partners/use-terraform-to-deploy-a-fortigate-ngfw?hl=en) with demo web server deployed directly into the firewall's internal subnet.

## Setup and requirements
### Before you click the Start Lab button
Read these instructions. Labs are timed and you cannot pause them. The timer, which starts when you click **Start Lab**, shows how long Google Cloud resources will be made available to you.

This hands-on lab lets you do the lab activities yourself in a real cloud environment, not in a simulation or demo environment. It does so by giving you new, temporary credentials that you use to sign in and access Google Cloud for the duration of the lab.

To complete this lab, you need:

* Access to a standard internet browser (Chrome browser recommended).  
    >*Note: Use an Incognito or private browser window to run this lab. This prevents any conflicts between your personal account and the Student account, which may cause extra charges incurred to your personal account.*

* Time to complete the lab---remember, once you start, you cannot pause a lab.  
> *Note: If you already have your own personal Google Cloud account or project, do not use it for this lab to avoid extra charges to your account.*

### How to start your lab and sign in to the Google Cloud Console
1. Click the **Start Lab** button. If you need to pay for the lab, a pop-up opens for you to select your payment method. On the left is the **Lab Details** panel with the following:
    * Time remaining
    * Your temporary credentials that you must use for this lab
    * Your temporary project ID
    * Links to additional student resources
2. Open Google Cloud console in new browser tab by clicking the **Google Cloud Console** link in **Student Resources**.
    ***Tip:*** Arrange the tabs in separate windows, side-by-side.
    > *Note: If you see the Choose an account dialog, click Use Another Account.*

3. Copy the **GCP Username** and **Password** from the **Lab Details** panel and paste it into the Sign in dialog. Click **Next**.
    > Important: You must use the credentials from the left panel. Do not use your Google Cloud Skills Boost credentials.

    >*Note: Using your own Google Cloud account for this lab may incur extra charges.*

4. Click through the subsequent pages:
    * Accept the terms and conditions.
    * Do not add recovery options or two-factor authentication (because this is a temporary account).
    * Do not sign up for free trials.
5. At the top bar select the project matching the Project ID in **Lab Details**.
6. Open the Cloud Shell in new browser tab by clicking the **Google Cloud Shell** link in the **Student Resources** and log in again using **GCP Username** and **Password** from the **Lab Details** panel. Cloud Shell is a virtual machine that is loaded with development tools. It offers a persistent 5GB home directory and runs on the Google Cloud. Cloud Shell provides command-line access to your Google Cloud resources.
7. Set active project for your Cloud Shell session by typing the command:

    ```
    gcloud config set project PROJECT_ID
    ```
    replacing PROJECT_ID with the **GCP Project ID** from the **Lab Details** panel.

> *Note: For full documentation of gcloud, in Google Cloud, refer to* [*the gcloud CLI overview guide.*](https://cloud.google.com/sdk/gcloud)

***Important:*** *make sure you are logged in using the temporary student username and you use the temporary qwiklabs project in both web console and cloud shell. Using your own project and username WILL incur charges.*


## Task 1: Cloning repository
This lab is fully automated using [Terraform by Hashicorp](https://www.terraform.io/). Terraform is one of the most popular tools for managing cloud infrastructure as code (IaC). While each cloud platform offers its own native tools for IaC, Terraform uses a broad open ecosystem of providers allowing creating and managing resources in any platform equipped with a proper API. In this lab you will use [google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) (by Google) to manage resources in Google Cloud and [fortios provider](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs) (by Fortinet) to manage FortiGate configuration.

All code for this lab is hosted in a public git repository. To use it start by creating a local copy of its contents.

1.	Run the following command in your Cloud Shell to clone the git repository contents:

    ```
    git clone https://github.com/40net-cloud/qwiklabs-fgt-terraform.git
    ```
2.	Change current working directory to **labs/day0** inside the cloned repository:

    ```
    cd qwiklabs-fgt-terraform/labs/day0
    ```
3. In the **Cloud Shell Editor** part of your Cloud Shell tab choose **File > Open** from the top menu and open the **qwiklabs-fgt-terraform/labs** folder. Cloud Shell Editor will be useful to navigate, review and edit terraform code during this lab.

![Cloud Editor open folder dialog](https://raw.githubusercontent.com/40net-cloud/qwiklabs-fgt-terraform/main/instructions/img/ide-open-folder.png)

For the Terraform, each directory containing **.tf** files is a module. A directory in which you run terraform command is the *root module* and can contain *submodules*. In this lab you will deploy two root modules: **day0** and **dayN** with each of them containing submodules. The module structure of **labs** in the cloned **qwiklabs-fgt-terraform** repository looks as follows:

- **labs/day0**
    - **fgcp-ha-ap-lb**
    - **sample-networks**
- **labs/dayN**
    - **app-infra**
    - **secure-inbound**
- **webapp** (does not contain terraform code)


## Task 2: Deploying FortiGate cluster
Using **day0** module you will deploy a standard active-passive HA cluster of 2 FortiGate VM instances with a complete Internal Load Balancer used as next hop for the default custom route on the internal (protected) side and an external backend service (load balancer without any frontends) on the external side. **day0** will also create all the necessary VPC networks and subnets, cloud firewall rules, custom route and a cloud NAT used for outbound connections initiated from FortiGates.

![day0 deployment architecture](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/diag-day0.png)

FortiGates are bootstrapped with an additional firewall policy allowing outbound traffic (defined in **fgt_config** variable for **fortigates** module in **day0/main.tf**). This policy will enable automated provisioning of web server in later steps.

### Customizing deployment through variables
Before deploying the **day0** module you have an opportunity to customize it. The module expects an input variable indicating the region to use.

As this lab is restricted to use us-central1 region, provide name the region in the **day0/terraform.tfvars** file:
`region = "us-central1"`


### FortiGate cluster deployment
Terraform deployment consists of 3 steps. Execute them now as described below:

1.	In **day0** directory initialize terraform using command

    ```  
    terraform init
    ```

    This will make terraform parse your **.tf** files for submodules and providers, and download necessary additional files. Re-run `terraform init` every time you add or remove providers and submodules
2.	Build a terraform plan and save it to **tf.plan** file by issuing command  

    ```
    terraform plan -out tf.plan
    ```

    Terraform plan file describes every resource to be created and dependencies between them. Planning phase also connects to every provider and checks the state file to verify if any of the resources described in the code already exist or have changed. You should always verify the output of `terraform plan` to understand what resources will be created, changed or destroyed.
3.	Create the resources according to the plan by issuing command  

    ```
    terraform apply tf.plan
    ```

    This command will attempt to create, delete or change the resources according to the plan. If run without providing a plan file `terraform apply` will create a new plan and immediately execute it after confirmation from operator. `terraform apply` should be executed every time after the code or variables change.

After `terraform apply` command completes you will see several output values which will be necessary in later steps. Terraform outputs can be used to provide additional information to the operator.

![Terraform apply output](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/tf-apply-day0.png)

### Reviewing the deployment
Once everything is deployed you can connect to the FortiGates to verify they are running and formed the cluster properly. In an FGCP (FortiGate Clustering Protocol) high-availability cluster all configuration changes are managed by the primary instance and automatically copied to the secondary. You can manage the primary instance using your web browser – the web console is available on standard HTTPS port – or via SSH. You will find the public IP address of your newly deployed FortiGate as well as the initial password in the terraform outputs.

1.	Select the value of `default_password` terraform output to copy it to clipboard
2.	Click the `primary_fgt_mgmt` URL in the outputs to open it in a new browser tab
3.	Log in as user `admin` with password from your clipboard
4.	Change the initial password to your own
5.	Login with your new password
6.	Skip through dashboard configuration, possible firmware upgrade offer and the welcome video
7.	Ignore the red FortiCare Support warning in the dashboard. It informs you that your support contract was not registered. Support contract is not available for this lab.
8.	In the menu on the left select **System > HA**  
    In the table you should see two FortiGate instances with different serial numbers and roles marked as “Primary” and “Secondary”. Initially, the secondary instance might be marked as “Out of sync”, but you can continue without waiting for the cluster to synchronize the configuration.

The **day0** module created a cluster and necessary load balancers, but did not create external load balancer frontend. External IP address and its related load balancer frontend will be created in the following step as part of the application deployment. You can verify that the load balancer **fgt-qlabs-bes-elb-us-central1** has no frontend attached in the GCP web console in **Network services** section available under the menu in top-left corner of the console. Use **Search** in the top bar if you cannot find **Network services** in the menu.

You can notice that the external load balancer has no healthy VMs in the backends list. As the health checks are triggered only after adding a frontend this does not indicate any issue with FortiGates or infrastructure configuration.

![ELB with no frontend](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/elb-no-frontend.png)

> *Note: At this point you have a fully functional cluster of FortiGates ready to protect traffic sent through it. In the next section you will deploy a web application, create a new public address for it, and redirect the traffic through FortiGate firewalls.*

## Task 3: Deploying demo application
In this step you will create a new VM and configure it to host a sample web page. While in the production deployments servers are usually deployed to a separate VPC network or even separate projects, this lab creates a single web server VM directly in the same internal subnet to which second network interface of the firewall is connected.

To enable access to the web server VM, **dayN** module utilizes a sample submodule (**secure-inbound**) to create a new external IP address, assign it as a frontend to the external load balancer and configure FortiGates with a new firewall policy and a virtual IP address for destination NAT.

![dayN deployment architecture](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/diag-dayn.png)

Note how leveraging a reusable submodule can abstract creation of all necessary resources in Google Cloud and in FortiGate.

```
module "secure_inbound" {
  source       = "./secure-inbound"

  prefix       = "${var.prefix}"
  protocol     = "TCP"
  port         = 80
  target_ip    = module.app.app_ip
  target_port  = 80

  region       = data.terraform_remote_state.day0.outputs.region
  elb_bes      = data.terraform_remote_state.day0.outputs.elb_bes
}
```

### Deploy web server and FortiGate configuration changes to existing environment
To deploy the sample web application go back to the cloud shell and issue the following commands:

```
cd ../dayN
terraform init
terraform plan –out tf.plan
terraform apply tf.plan
```

This time you didn’t have to provide any variables to terraform, because all necessary values (including the region you selected for **day0** module) were automatically pulled by terraform. The possible mechanisms for sharing data between multiple terraform deployments are described in the next section.

### Sharing data between terraform deployments
It is a common scenario where the cloud environment is built in a series of multiple separate deployments. This approach allows to limit the blast radius and makes the code more manageable (often by different teams). In this lab we use a base firewall deployment which in real life would be usually managed by NetSecOps team and a web application deployment managed typically by the application DevOps team. As our goal is to have the application deployment trigger changes to the firewall configuration, both deployments will have to share some common data like the identifiers of firewall-related resources or the FortiGate API access token. There are multiple ways to share this information:

#### Option 1: terraform state file
Terraform saves the current state of the deployment into a state file. State contains all the data terraform needs to link a resource described in the code with its instantiation in the cloud (which doesn’t have to be obvious, as sometimes the name you assign to the resource will not uniquely identify it). It also contains the values of all outputs of your deployment. While it’s a good practice to save the state files in one of multiple available cloud vaults or cloud storage backends available, in this lab we use a simplified approach and save it to a local file on the cloud shell instance disk.

State files can be read, parsed and imported by terraform using the following code used in **dayN/import-day0.tf** file:

```
data "terraform_remote_state" "day0" {
  backend = "local"

  config  = {
    path = "../day0/terraform.tfstate"
  }
}
```

you can later reference the retrieved output values as shown in **dayN/main.tf**:

```
module "app" {
[...]
  subnet       = data.terraform_remote_state.day0.outputs.internal_subnet
  region       = data.terraform_remote_state.day0.outputs.region
}
```

Note, that while `terraform_remote_state` data block gives access only to the output values, the state file itself contains data you should always treat as confidential and protect as such.

#### Option 2: Secret Manager
Similar to pulling information about the resources from the state file, you can utilize a service specifically designed to store secrets: [Secret Manager](https://cloud.google.com/secret-manager). Using Secret Manager allows building permissions around the CI/CD pipeline, which will make the secret value available to the pipeline, but not to any human operators. As an example we use Secret Manager to store and retrieve the FortiGate API access token:

Created and saved in **day0/fgcp-ha-ap-lb/main.tf**:

```
resource "google_secret_manager_secret" "api-secret" {
  secret_id      = "${google_compute_instance.fgt-vm[0].name}-apikey"
}
resource "google_secret_manager_secret_version" "api_key" {
  secret         = google_secret_manager_secret.api-secret.id
  secret_data    = random_string.api_key.id
}
```

and later retrieved in **dayN/providers.tf**:  

```
data "google_secret_manager_secret_version" "fgt-apikey" {
  secret         = "${data.google_compute_instance.fgt1.name}-apikey"
}
```

#### Option 3: no sharing
You should always make sure you really need to share any data between modules. Terraform offers a possibility to query the APIs for needed values using its data blocks. You should consider using data instead of sharing variables especially for data that might change over time. For example: if management IP addresses are ephemeral, they may easily drift away from the values known right after initial deployment. The code retrieving the information about primary FortiGate directly from Google Compute API can be found in **dayN/providers.tf**:


```
data "google_compute_instance" "fgt1" {
  self_link = data.terraform_remote_state.day0.outputs.fgt_self_links[0]
}
```

And the current public IP of management interface (port4) used later in the same file:

```
provider "fortios" {
  hostname = data.google_compute_instance.fgt1.network_interface[3].access_config.nat_ip
}
```

### Verifying the complete setup
Terraform **dayN** module deployed the web application and configured FortiGate to allow secure access to it. The steps below will help you verify and understand the elements of this infrastructure:

1.	Verify that the website is available by clicking the application URL from terraform outputs. A sample webpage should open in a new browser tab. If it’s not available immediately retry after a moment. It takes about a minute for the webserver to start. You should see a simple web page similar to this one:
![Sample "It works!" webpage screenshot](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/itworked.png)
2.	You can now go back to FortiGate web console and use the menu on the left to navigate to Log & Report > Forward Traffic. You will find connections originating from your computer's public IP with destination set to the IP address of the application (which is the address of the external network load balancer). You can click Add Filter and set Destination Port: 80 to filter out the noise.
![FortiGate forwarding log](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/fwlog.png)
3.	In the next step you will verify that FortiGate threat inspection is enabled by attempting to download Eicar - a non-malicious malware test file. Click “Try getting EICAR” button in the middle of the demo web page. Your attempt will be blocked.
4.	In the FortiGate web console refresh the Forward Traffic log to show new entries. One of them will be marked as “Deny: UTM blocked”. Double-click the entry and select “Security” tab in the Log Details frame to show details about the detected threat.
![FortiGate blocked connection log details](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/fwlog-details.png)

> In this section you performed tests to verify the newly deployed application is properly deployed and protected against threats by FortiGate next-gen firewall.

## Task 4: Configuration drift
It can happen that the resources managed by the terraform code are changed manually. After such a change the code, state file and the real configuration are not aligned. It certainly is not a desired situation and is called a “drift”. In this section you will introduce a FortiGate configuration drift and use terraform to fix it.

1.	Connect to FortiGate web console and use menu on the left to navigate to **Policy & Objects > Firewall Policy**. Double-click the **demoapp1-allow** rule in **port1-port2** section, disable all security profiles and save the policy by clicking **OK** button at the bottom.
2.	In the **dayN** directory in Cloud Shell run the following command:  

    ```
    terraform plan -refresh-only
    ```

    The `-refresh-only` parameter instructs terraform to only indicate the changes but not plan them or update the state.  
    ![Screenshot after "terraform plan -refresh-only"](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/tfrefreshonly.png)
3.	To remediate this drift and revert to the configuration described in the terraform file run the   

    ```
    terraform apply
    ```

    command. You can refresh the firewall policy list in FortiGate web console to verify the security profiles were re-enabled.
4.	Mind that not all configuration changes will be detected. To check it, while in FortiGate Firewall Policy list delete the **allow-all-outbound** policy in **port2-port1** section and run again the terraform plan `-refresh-only` command. This time there was no drift detected.  
    ![Terraform detects no drift - screenshot](https://github.com/40net-cloud/qwiklabs-fgt-terraform/raw/main/instructions/img/tf-nodrift.png)  
    The reason for this behavior is that only part of FortiGate configuration is managed by terraform. The deleted policy was part of the bootstrap configuration applied during initial firewall deployment (you can find it in **day0/main.tf** file, module “fortigates” block, fgt_config variable).

In many organizations mixing manual and managed configuration is not desired. It provides flexibility but requires extra care when these two types of configuration overlap. Remember that parts of configuration created manually will not be automatically visible to terraform.

### Congratulations!
Congratulations, you have successfully deployed and configured FortiGates in Google Cloud using terraform. The skills and concepts you have learned can help you build secure environments leveraging network security experience of FortiGuard Labs combined with cloud-native workflows, eliminating the requirement to interactively log into the firewall management console.

</details>

***

# LAB 3 - VPC Peering: Create/Configure VPC Peering between two Virtual Private Cloud (VPC) networks

<details>
    
## Google Cloud VPC Network Peering connects two Virtual Private Cloud (VPC) networks so that resources in each network can communicate with each other

## Benefits of VPC Network Peering

VPC Network Peering has the following benefits:
Network Latency: Connectivity that uses only internal addresses provides lower latency than connectivity that uses external addresses.
Network Security: Service owners do not need to have their services exposed to the public Internet and deal with its associated risks.
Network Cost: Google Cloud charges egress bandwidth pricing for networks using external IP addresses to communicate even if the traffic is within the same zone. If however, the networks are peered they can use internal IP addresses to communicate and save on those egress costs. Regular network pricing still applies to all traffic.

https://cloud.google.com/vpc/docs/vpc-peering

## Overview
This lab is intended to Create/Configure VPC Peering between two Virtual Private Cloud (VPC) networks and secure the workloads by routing the traffic through FortiGate(Hub).

### Objectives
In this lab you will:

- Create/Configure VPC peering between "Internal/Private/Trust VPC Network of FortiGate's Cluster" and "Web Server VPC Network". 
- Notice on how the routes are exchanged and the traffic flow between the instances which reside in different VPC's, once  VPC Peering is created/configured.

## Setup and requirements
### Before you click the Start Lab button
Read these instructions. Labs are timed and you cannot pause them. The timer, which starts when you click **Start Lab**, shows how long Google Cloud resources will be made available to you.

This hands-on lab lets you do the lab activities yourself in a real cloud environment, not in a simulation or demo environment. It does so by giving you new, temporary credentials that you use to sign in and access Google Cloud for the duration of the lab.

To complete this lab, you need:

* Access to a standard internet browser (Chrome browser recommended).  
    >*Note: Use an Incognito or private browser window to run this lab. This prevents any conflicts between your personal account and the Student account, which may cause extra charges incurred to your personal account.*

* Time to complete the lab---remember, once you start, you cannot pause a lab.  
> *Note: If you already have your own personal Google Cloud account or project, do not use it for this lab to avoid extra charges to your account.*

### How to start your lab and sign in to the Google Cloud Console
1. Click the **Start Lab** button. If you need to pay for the lab, a pop-up opens for you to select your payment method. On the left is the **Lab Details** panel with the following:
    * Time remaining
    * Your temporary credentials that you must use for this lab
    * Your temporary project ID
    * Links to additional student resources
2. Open Google Cloud console in new browser tab by clicking the **Google Cloud Console** link in **Student Resources**.
    ***Tip:*** Arrange the tabs in separate windows, side-by-side.
    > *Note: If you see the Choose an account dialog, click Use Another Account.*

3. Copy the **GCP Username** and **Password** from the **Lab Details** panel and paste it into the Sign in dialog. Click **Next**.
    > Important: You must use the credentials from the left panel. Do not use your Google Cloud Skills Boost credentials.

    >*Note: Using your own Google Cloud account for this lab may incur extra charges.*

4. Click through the subsequent pages:
    * Accept the terms and conditions.
    * Do not add recovery options or two-factor authentication (because this is a temporary account).
    * Do not sign up for free trials.
5. At the top bar select the project matching the Project ID in **Lab Details**.
6. Open the Cloud Shell in new browser tab by clicking the **Google Cloud Shell** link in the **Student Resources** and log in again using **GCP Username** and **Password** from the **Lab Details** panel. Cloud Shell is a virtual machine that is loaded with development tools. It offers a persistent 5GB home directory and runs on the Google Cloud. Cloud Shell provides command-line access to your Google Cloud resources.
7. Set active project for your Cloud Shell session by typing the command:

    ```
    gcloud config set project PROJECT_ID
    ```
    replacing PROJECT_ID with the **GCP Project ID** from the **Lab Details** panel.

> *Note: For full documentation of gcloud, in Google Cloud, refer to* [*the gcloud CLI overview guide.*](https://cloud.google.com/sdk/gcloud)

***Important:*** *make sure you are logged in using the temporary student username and you use the temporary qwiklabs project in both web console and cloud shell. Using your own project and username WILL incur charges.*

## LAB 3 - Task 1: Make sure to complete the "FortiGate: Automating deployment and configuration using Terraform" Lab
Make sure "FortiGate: Automating deployment and configuration using Terraform" Lab is done as we will be utilising the resources .i.e. FortiGates, VPCs which were deployed.

## LAB 3 - Task 2: Cloning repository which creates a new Virtual Private Cloud (VPC) network and deploys a web server
This lab is fully automated using [Terraform by Hashicorp](https://www.terraform.io/). Terraform is one of the most popular tools for managing cloud infrastructure as code (IaC). While each cloud platform offers its own native tools for IaC, Terraform uses a broad open ecosystem of providers allowing creating and managing resources in any platform equipped with a proper API. In this lab you will use [google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) (by Google) to manage resources in Google Cloud.

All code for this lab is hosted in a public git repository. To use it start by creating a local copy of its contents.

1.	Run the following command in your Cloud Shell to clone the git repository contents:

    ```
    git clone https://github.com/fortinetsolutions/terraform-modules.git
    ```
2.	Change current working directory to **GCP/qwiklabs/vpc-peering** inside the cloned repository:

    ```
    cd terraform-modules/GCP/qwiklabs/vpc-peering
    ```
3. In the **Cloud Shell Editor** part of your Cloud Shell tab choose **File > Open** from the top menu and open the **terraform-modules/qwiklabs/vpc-peering** folder. Cloud Shell Editor will be useful to navigate, review and edit terraform code during this lab.

For the Terraform, each directory containing **.tf** files is a module. A directory in which you run terraform command is the *root module* and can contain *submodules*. In this lab you will deploy a root module: **vpc-peering** containing submodules.


## LAB 3 - Task 3: Deploying Web Server
Using **vpc-peering** module you will deploy a nginx web server in a VPC .

### Customizing deployment through variables
Before deploying the **vpc-peering** module you have an opportunity to customize it. The module expects an input variable indicating the region to use.

As this lab is restricted to use us-central1 region, provide name the region in the **vpc-peering/terraform.tfvars** file:
`region = "us-central1"`

You also have to indicate the GCP project to deploy to by setting `project` variable in **vpc-peering/terraform.tfvars** to the name of your qwiklabs project indicated as **GCP Project ID** in the **Lab Details** panel. 

### Web Server deployment
Web Server deployment consists of 3 steps. Execute them now as described below:

1.	In **vpc-peering** directory initialize terraform using command

    ```  
    terraform init
    ```

    This will make terraform parse your **.tf** files for submodules and providers, and download necessary additional files. Re-run `terraform init` every time you add or remove providers and submodules
2.	Build a terraform plan and save it to **tf.plan** file by issuing command  

    ```
    terraform plan
    ```

    Terraform plan file describes every resource to be created and dependencies between them. Planning phase also connects to every provider and checks the state file to verify if any of the resources described in the code already exist or have changed. You should always verify the output of `terraform plan` to understand what resources will be created, changed or destroyed.
3.	Create the resources according to the plan by issuing command  

    ```
    terraform apply
    ```

    This command will attempt to create, delete or change the resources according to the plan. If run without providing a plan file `terraform apply` will create a new plan and immediately execute it after confirmation from operator. `terraform apply` should be executed every time after the code or variables change.

After `terraform apply` command completes you will see several output values which will be necessary in later steps. Terraform outputs can be used to provide additional information to the operator.

### Reviewing the deployment
Once everything is deployed you can see the sample page of the Web Server when you enter the External IP of the Compute Engine Instance.
> *Note: It is recommended not to have an External IP for this Web Server. 

## LAB 3 - Task 4: VPC Peering
In this step you will configure VPC Peering between the "Internal/Private/Trust VPC Network" with the "Web Server VPC Network" which is used for deploying the Web Server

Before creating peerings go back and review the routing. Any new VPC Network is created with a default route via default internet gateway. As you will be creating a peering between the web server VPC and the FortiGate VPC, the desired routing is via FortiGate. To avoid routing conflict you must delete the automatically created default route.

1. Open the VPC network details page for "qwiklabs-webserver-public-vpc"
2. Click the "ROUTES" tab
3. Select the "Default route to Internet" and click "Delete" button

![VPC route list](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/vpc_delete_default_route.png)

4. The route list should now contain only the "Default local route to the subnetwork 172.29.1.0/24" 

Now it's time to create the VPC peerings:

1. Open VPC network peering page from the Console under the "VPC Network" menu

![VPC network peering page](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/vpc_network_peering.png)

2. Click on "Create Peering Connection"

![VPC network peering create](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/create_peering_connection.png)

3. Click Continue
4. Give a name to the Peering Connection
5. Select the Internal/Private/Trust VPC Network of the FortiGate's Cluster
6. Select the Peering Network, .i.e the VPC Network used for deploying the Web Server
7. Choose "Export custom routes" as the "Internal/Private/Trust VPC Network" (HUB VPC Network) will export the routes while the Spokes .i.e. the "Web Server VPC Network" will import.
8. Ignore the defaults which are selected.
9. Click Create.

![VPC network peering details](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/vpc_peering_details_1.png)

Routes are only exchanged when the peering is done from both the sides .i.e. from the "Internal/Private/Trust VPC Network" and "Web Server VPC Network" and vice versa.

You will notice the Status of the VPC Peering as "inactive" until you create the VPC peering from both sides.

10. Repeat the above steps 4-9 but choose "Web Server VPC Network" in Step-5, and "Internal/Private/Trust VPC Network" on Step-6.
11. Choose "Import custom routes" as "Web Server VPC Network" will import routes acting as a Spoke.
12. Click Create.

![VPC network peering details](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/vpc_peering_details_2.png)

Within couple of seconds you will notice Status change to "Active" with Green Tick Icon, and routes being exchanged.

![VPC network peering status](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/vpc_peering_active.png)

## LAB 3 - Task 5: Add the Static route in FGT
Login into the Primary FortiGate of the cluster and create a static route under "Network" menu

1. Destination will be the CIDR range of the Subnet of the "Web Server VPC Network"
2. Gateway Address will be the "Internal/Private/Trust VPC Network" Gateway
3. Interface will be "port2"
4. Click "OK"

![FGT Static Route](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/fgt_static_route.png)

Once the Task 5 is completed, one can validate the static route in routing-table of FortiGate from the CLI console of FortiGate, by executing the below command

```
get router info routing-table all
```

![FGT Static Route](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/fgt_routing_table.png)

## LAB 3 - Task 6: See the communication
From the FortiGate CLI console, if you ping the Internal IP address of the WebServer, you will notice the response from the Web Server

```
exec ping <INTERNAL_IP_ADDRESS>
```

![FGT Static Route](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/vpc-peering/instructions/img/fgt_ping.png)


### Congratulations!
Congratulations, you have successfully configured the VPC Peering. The skills and concepts you have learned can help you build secure environments leveraging network security experience of FortiGuard Labs combined with cloud-native workflows, eliminating the requirement to interactively log into the firewall management console.

</details>

***
# LAB 4 -  Create Network Overlay and Configure SD-WAN Components

 <details>
     
In previous labs, we built a Cloud on-ramp using two FortiGates deployed as a High Availability pair sandwiched between two Load Balancers.  We also built a remote site using a single FortiGate and Ubuntu server.  The next step is to securely connect the remote location with the cloud on-ramp.  In the following excercises, we will configure the IPsec overlay.  BGP will be used to share routes between locations.  Once the overlay is in place, we will configure SD-WAN to monitor SLA

* Network Diagram

    ![diagram1](https://github.com/fortidg/markdown-test/blob/main/images/full-network-diagram.png)

***

## Chapter 1 - Build Network Overlay

***[Deployment exercise - estimated duration 45min]***

<details>

<summary>In this chapter, we will create the dialup IPsec VPN hub on the on-ramp FortiGate and configure the remote site to connect to it.   </summary>

### Task 1 - Add Forwarding Rule to the Load Balancer

#### Tidbit - There is no way to add forwarding rules to the Load Balancer using the GUI Console.  For this step, we will need to open a cloud shell and use the Google SDK.  As you will see in the following steps, we need to create forwarding rules to allow the load balancer to forward UDP ports 500 and 4500 to the FortiGate

* We will be using the below Google sdk command to create the forwarding rule.  Copy and paste the below command into your favorite text editor.  The next few steps will help us get the require environment variables (project-id, lb-ip)

```sh
gcloud compute forwarding-rules create udp-ipsec --backend-service=projects/<project-id>/regions/us-central1/backendServices/fgt-qlabs-bes-elb-us-central1 --address=<lb-ip> --ports=500,4500 --region=us-central1 --ip-protocol=UDP
```

* From the GCP console dashboard, select click on the cursor **>_** at the top of the screen.  This will open a **CLOUD SHELL Terminal** at the bottom of the screen.

    ![overlay1](https://github.com/fortidg/markdown-test/blob/main/images/open-shell.png)

* Get the project-id by copying it from the cloud shell prompt.  We do not need the open and close parentheses.

    ![overlay2](https://github.com/fortidg/markdown-test/blob/main/images/get-project.png)

* Get the lb-ip.  Under hamburger menu  select MORE PRODUCTS > Network services > **Load balancing**.  In the center of the screen, Click on LOAD BALANCERS > **fgt-qlabs-bes-elb-us-central1**.

    ![overlay3](https://github.com/fortidg/markdown-test/blob/main/images/load-balancing.png)

* In the center of the screen, under **Frontend** copy the IP address

    ![overlay4](https://github.com/fortidg/markdown-test/blob/main/images/frontend-ip.png)

* Once you have the project-id and lb-ip, update the sdk command from earlier and input it into the cloud shell.  Below is an example of what that command should look like.

    ![overlay5](https://github.com/fortidg/markdown-test/blob/main/images/sdk-sample.png)

* You should now see the new rule under **Frontend**

### Task 2 - Configure IPsec VPN Hub on cloud on-ramp FortiGate

#### Tidbit - The GCP Load Balancer does not perform Destination NAT on inbound traffic to the FortiGate, meaning that the Destination IP address in the UDP port 500 IPsec packets are set to the Load Balancer's external IP address.  We will need to add this IP as secondary to the "WAN" interface (port1) on FortiGate

* Log into the active FortiGate of the cloud on-ramp HA pair.  On the left pane, select **Network** > **Inerfaces**.  Click on port1 and select **Edit**  Under Address, toggle the **Secondary IP address** button and input the lb-ip from earlier.

    ![overlay6](https://github.com/fortidg/markdown-test/blob/main/images/secondary-ip.png)

* Open a CLI console in the active FortiGate by clicking on the cursor **>_** icon or using SSH to the public management IP.  Copy the below configurations into your favorite text editor and "set local-gw" to the lb-ip. Once completed, copy and paste thes configurations into the cli console.

```sh
config vpn ipsec phase1-interface
    edit HUB1
        set type dynamic
        set interface port1
        set ike-version 2
        set local-gw <lb-ip>
        set peertype any
        set net-device disable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set dpd on-idle
        set ipv4-start-ip 10.10.1.2
        set ipv4-end-ip 10.10.1.25
        set ipv4-netmask 255.255.255.0
        set psksecret Fortinet1!
        set dpd-retryinterval 60
    next
end


config vpn ipsec phase2-interface
    edit HUB1
        set phase1name HUB1
        set proposal aes256-sha256
    next
end
config system interface
   edit HUB1
        set vdom root
        set ip 10.10.1.254 255.255.255.255
        set allowaccess ping
        set type tunnel
        set remote-ip 10.10.1.1 255.255.255.0
        set snmp-index 18
        set interface port1
    next
end

config firewall policy
    edit 0
        set name ipsec-in
        set srcintf HUB1
        set dstintf port2
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat enable
    next
    edit 0
        set name ipsec-internet
        set srcintf HUB1
        set dstintf port1
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat enable
    next
end

```

#### Tidbit - Notice that we are using mode config here.  This will result in IP addresses being dynamically assigned to the IPsec interface on the remote sites.  Make a mental note of the "ip4v-start-ip" and "ipv4-stop-ip".  This range will be used later to configure BGP

### Task 3 - Configure IPsec VPN on remote site

* Open a CLI console in the FortiGate by clicking on the cursor **>_** icon or using SSH to the public management IP.  Copy the below configurations into your favorite text editor and "set remote-gw" to the lb-ip. Once completed, copy and paste thes configurations into the cli console.

```sh
config vpn ipsec phase1-interface
    edit HUB1
        set interface port1
        set ike-version 2
        set peertype any
        set net-device disable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set dpd on-idle
        set remote-gw <lb-ip>
        set psksecret Fortinet1!
    next
end


config vpn ipsec phase2-interface
    edit HUB1
        set phase1name HUB1
        set proposal aes256-sha256
        set auto-negotiate enable

    next
end

config firewall policy
    edit 0
        set name ipsec-out
        set srcintf port2
        set dstintf HUB1
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat disable
    next
    edit 0
        set name ipsec-in
        set srcintf HUB1
        set dstintf port2
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat enable
    next
end
```

* Run the below commands to ensure that the tunnels are up and functioning proplerly.

```sh
get vpn ipsec tunnel summary
diagnose vpn ike gateway list name HUB1
```

#### Useful Link - https://community.fortinet.com/t5/FortiGate/Troubleshooting-Tip-IPsec-VPNs-tunnels/ta-p/195955

### Task 4 - Configure BGP on cloud on-ramp FortiGate

* Copy the below BGP configurations and paste them into the active FortiGate's CLI console.

```sh
config router bgp
    set as 65400
    set ibgp-multipath enable
    set additional-path enable 
    set additional-path-select 4
    config neighbor-group
        edit HUB1
            set remote-as 65400
            set additional-path both
            set adv-additional-path 4
            set route-reflector-client enable
        next
    end
    config neighbor-range
        edit 1
            set prefix 10.10.1.0 255.255.255.0
            set max-neighbor-num 20
            set neighbor-group HUB1
        next
end

    config network
        edit 1
            set prefix 172.20.1.0 255.255.255.0
        next
    end
end
```

#### Tidbit - note the prefix setting under "config neighbor-range".  The dynamic IP addresses assigned to the remote site IPsec VPN interfaces fall within that range, meaning that this router will accept any bgp peer request from those remote sites.

### Task 4 - Configure BGP on remote FortiGate

* Copy the below BGP configurations and paste them into the FortiGate's CLI console.

```sh
config router bgp
    set as 65400
    set ibgp-multipath enable
    set additional-path enable
    set additional-path-select 4
    config neighbor
        edit 10.10.1.254
            set remote-as 65400
            set additional-path receive
        next
    end
    config network
        edit 1
            set prefix 192.168.129.0 255.255.255.128
        next
    end
end

```

* Ensure that BGP peers are established and that routes are being shared on both the hub and remote site.

```sh
get router info bgp summary
get router info routing-table bgp
```

* Below are the expected outputs

    ![overlay7](https://github.com/fortidg/markdown-test/blob/main/images/hub-bgp-sum.png)

    ![overlay8](https://github.com/fortidg/markdown-test/blob/main/images/spoke-bgp-sum.png)    

* Ensure continuity from Hub by pinging the remote site Ubuntu server.

```sh
execute ping 192.168.129.3
```

* Ensure continuity from remote site by pinging the Hub Ubuntu server.

```sh
execute ping 172.20.1.5
```

***

</details>

## Chapter 2 - Configure SD-WAN

***[Make it work - estimated duration 15min]***

<details>

<summary>Now that we have configured the overlay, we will add the "WAN" interface (port1) and the IPsec HUB1 interface to SD-WAN.  We will then create SLA monitoring in the remote site.</summary>

### Task 1 - Add interfaces to SD-WAN

#### Tidbit - In FortiOS, interfaces which already have policies attached to them are precluded from being added to SD-WAN.

* On the remote FortiGate, delete the existing firewall policies by opening a console connection and inputting the below configuration.  **Note: This will cause the IPsec tunnel to go down**

```sh
config firewall policy
delete 1
delete 2
delete 3
delete 4
end
```

* Navigate to **Network > SD-WAN** and click on **Create New > SD-WAN Member** From the **Interface** drop down, choose **port1**.  Leave all other values as default.

    ![overlay9](https://github.com/fortidg/markdown-test/blob/main/images/new-sdwan-member.png)

* Navigate to **Network > SD-WAN** and click on **Create New > SD-WAN Member** From the **Interface** drop down, choose **HUB1**.  In the **SD-WAN Zone** drop down, click **Create** and name the new zone "overlay".  Leave all other values as default and click **OK** 

    ![overlay10](https://github.com/fortidg/markdown-test/blob/main/images/hub1-sdwan.png)

* Open a Console connection and add the below firewall policies.

```sh
config firewall policy
    edit 0
        set name overlay-out
        set srcintf port2
        set dstintf overlay
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service SMTP
        set nat enable
    next
    edit 0
        set name vip-in
        set srcintf virtual-wan-link
        set dstintf port2
        set action accept
        set srcaddr all
        set dstaddr ubu-serv
        set schedule always
        set service HTTP
        set nat enable
    next
    edit 0
        set name overlay-in
        set srcintf overlay
        set dstintf port2
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat enable
    next
    edit 0
        set name port2-out
        set srcintf port2
        set dstintf virtual-wan-link
        set action accept
        set srcaddr all
        set dstaddr all
        set schedule always
        set service ALL
        set nat enable
    next
end
```

#### Tidbit - After interfaces have been added to SD-WAN, Policies are configured using the SD-WAN zone.  This simplifies policy configuration once multiple interfaces are added to the zones

#### useful link - https://docs.fortinet.com/document/fortigate/7.2.3/administration-guide/942095/sd-wan-members-and-zones

### Task 2 - Create SLA monitoring

* Navigate to **Network > SD-WAN > Performance SLAs** and select the test named **Default_Google_Search"**.  Click **Edit**. Under **Participants** select **All SD-WAN Members**.  Leave all other values as default and click **OK**.  

    ![overlay11](https://github.com/fortidg/markdown-test/blob/main/images/google-sla.png)

* You may need to refresh the browser in order to see the SLA measurements.  Click on **Default_Google Search**.  You should now see performance data updating in real time for both the **HUB1** and **port1** interfaces.

    ![overlay12](https://github.com/fortidg/markdown-test/blob/main/images/google-mon.png)

* In the fires two steps, we used the default Googel performance SLA monitor.  While it's not unheard of to monitor a Public internet site over an IPSec tunnel to the cloud, a more realistic scenario would be to monitor a resource in our own cloud "Data Center"  Below is an example of a custom performance SLA monitoring hour Hub Ubunt Server (created in lab 3).

    ![overlay13](https://github.com/fortidg/markdown-test/blob/main/images/ubu-hub-mon.png)

#### useful link - https://docs.fortinet.com/document/fortigate/7.2.3/administration-guide/584396/performance-sla

### Task 3 - Create SD-WAN Rules

* Navigate to **Network > SD-WAN > SD-WAN Rules**.  Click **Create new**  Feel free to play around with the Values here.  At a minimum you will need to provide **Name**, **Destination Address or Internet Service**, **Interface selection strategy** and **Interface and/or Zone preference**.  **Note: The minimum required information will change, depending on which selection strategy you choose.  Our example below uses Best Quality, which additionally, requires us to choos a Measured SLA and Quality Criteria**

    ![overlay14](https://github.com/fortidg/markdown-test/blob/main/images/oci-rule.png)

#### useful link - https://docs.fortinet.com/document/fortigate/7.2.3/administration-guide/716691/sd-wan-rules 

* **Congratulations!** You have completed this course!  Please answer the questions below.

***
  </details>

***

## Quiz


### Question 1

* All GCP features can be configured from the GUI Console  (True or False)

<details> 

<summary>Answer</summary>

* **False** - As we saw with load balancer forwarding rules, some configurations are only available using the gcloud cli.

</details>

## Question 2

* Which hub ipsec phase1-interface setting enables dynamic assignment of IP address to remote peers?
    a) set type dynamic
    b) set add-route disable
    c) set mode-cfg enable
    d) set peertype any

<details> 

<summary>Answer</summary>

* **C** - set mode-cfg enable along with  set ipv4-start-ip, set ipv4-end-ip and set ipv4-netmask are required on the hub to enable this feature.

</details>

## Question 3

* You must use the Zone ID in security policy for any interface which is added to SD-WAN (TRUE or False)

<details> 

<summary>Answer</summary>

* **True** - once an interface is part of SD-WAN, you can no longer assign policy direcly to that interface.

</details>
    
</details>

##  Clean-up
To revert changes and remove resources you created in this lab do the following:

1.	To delete the demo application: in the Cloud Shell, issue the following command while in **GCP/qwiklabs/vpc-peering** directory:  

    ```
    terraform destroy
    ```

    confirm your decision to delete the resources by typing `yes`

2. Click **End Lab** button in **Lab Details** panel.
