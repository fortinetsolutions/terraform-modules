# VPC Peering: Create/Configure VPC Peering between two Virtual Private Cloud (VPC) networks
Google Cloud VPC Network Peering connects two Virtual Private Cloud (VPC) networks so that resources in each network can communicate with each other

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

## Task 1: Make sure to complete the "FortiGate: Automating deployment and configuration using Terraform" Lab
Make sure "FortiGate: Automating deployment and configuration using Terraform" Lab is done as we will be utilising the resources .i.e. FortiGates, VPCs which were deployed.

## Task 2: Cloning repository which creates a new Virtual Private Cloud (VPC) network and deploys a web server
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


## Task 3: Deploying Web Server
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

## Task 4: VPC Peering
In this step you will configure VPC Peering between the "Internal/Private/Trust VPC Network" with the "Web Server VPC Network" which is used for deploying the Web Server

Before creating peerings go back and review the routing. Any new VPC Network is created with a default route via default internet gateway. As you will be creating a peering between the web server VPC and the FortiGate VPC, the desired routing is via FortiGate. To avoid routing conflict you must delete the automatically created default route.

1. Open the VPC network details page for "qwiklabs-webserver-public-vpc"
2. Click the "ROUTES" tab
3. Select the "Default route to Internet" and click "Delete" button

![VPC route list](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/vpc_delete_default_route.png)

4. The route list should now contain only the "Default local route to the subnetwork 172.29.1.0/24" 

Now it's time to create the VPC peerings:

1. Open VPC network peering page from the Console under the "VPC Network" menu

![VPC network peering page](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/vpc_network_peering.png)

2. Click on "Create Peering Connection"

![VPC network peering create](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/create_peering_connection.png)

3. Click Continue
4. Give a name to the Peering Connection
5. Select the Internal/Private/Trust VPC Network of the FortiGate's Cluster
6. Select the Peering Network, .i.e the VPC Network used for deploying the Web Server
7. Choose "Export custom routes" as the "Internal/Private/Trust VPC Network" (HUB VPC Network) will export the routes while the Spokes .i.e. the "Web Server VPC Network" will import.
8. Ignore the defaults which are selected.
9. Click Create.

![VPC network peering details](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/vpc_peering_details_1.png)

Routes are only exchanged when the peering is done from both the sides .i.e. from the "Internal/Private/Trust VPC Network" and "Web Server VPC Network" and vice versa.

You will notice the Status of the VPC Peering as "inactive" until you create the VPC peering from both sides.

10. Repeat the above steps 4-9 but choose "Web Server VPC Network" in Step-5, and "Internal/Private/Trust VPC Network" on Step-6.
11. Choose "Import custom routes" as "Web Server VPC Network" will import routes acting as a Spoke.
12. Click Create.

![VPC network peering details](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/vpc_peering_details_2.png)

Within couple of seconds you will notice Status change to "Active" with Green Tick Icon, and routes being exchanged.

![VPC network peering status](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/vpc_peering_active.png)

## Task 5: Add the Static route in FGT
Login into the Primary FortiGate of the cluster and create a static route under "Network" menu

1. Destination will be the CIDR range of the Subnet of the "Web Server VPC Network"
2. Gateway Address will be the "Internal/Private/Trust VPC Network" Gateway
3. Interface will be "port2"
4. Click "OK"

![FGT Static Route](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/fgt_static_route.png)

Once the Task 5 is completed, one can validate the static route in routing-table of FortiGate from the CLI console of FortiGate, by executing the below command

```
get router info routing-table all
```

![FGT Static Route](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/fgt_routing_table.png)

## Task 6: See the communication
From the FortiGate CLI console, if you ping the Internal IP address of the WebServer, you will notice the response from the Web Server

```
exec ping <INTERNAL_IP_ADDRESS>
```

![FGT Static Route](https://github.com/skchi/GCP/blob/master/qwiklabs/vpc-peering/instructions/img/fgt_ping.png)


### Congratulations!
Congratulations, you have successfully configured the VPC Peering. The skills and concepts you have learned can help you build secure environments leveraging network security experience of FortiGuard Labs combined with cloud-native workflows, eliminating the requirement to interactively log into the firewall management console.

##  Clean-up
To revert changes and remove resources you created in this lab do the following:

1.	To delete the demo application: in the Cloud Shell, issue the following command while in **GCP/qwiklabs/vpc-peering** directory:  

    ```
    terraform destroy
    ```

    confirm your decision to delete the resources by typing `yes`

2. Click **End Lab** button in **Lab Details** panel.
