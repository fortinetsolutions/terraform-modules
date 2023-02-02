# FortiWeb
FortiWeb Web Application firewall enables enterprises to protect their web applications in GCP through Fortinet solutions. Fortinet solutions provide the freedom to deploy any application in Google Cloud without compromising security.

## Overview
This lab allows you to experience how a FortiWeb Web Application firewall enables enterprises to protect their web applications in Google Cloud through Fortinet solutions. Fortinet solutions provide the freedom to deploy any application on Google Cloud without compromising security. 

https://docs.fortinet.com/document/fortiweb-public-cloud/latest/deploying-fortiweb-from-google-cloud-marketplace/195813/initial-deployment

### Objectives
In this lab:

- You will configure Server objects, Virtual servers, and Server policies on the FortiWeb-VM via the FortiWeb GUI to install and enable a webserver (Juice-Shop) hosted in GCP access to the Internet and then enable Virtual IPs to protect the web servers against OWASP Top 10 and other web attacks by the FortiWeb.

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
    >*Note: If you see the Choose an account dialog, click Use Another Account.*

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

    >*Note: For full documentation of gcloud, in Google Cloud, refer to* [*the gcloud CLI overview guide.*](https://cloud.google.com/sdk/gcloud)

***Important:*** *make sure you are logged in using the temporary student username and you use the temporary qwiklabs project in both web console and cloud shell. Using your own project and username WILL incur charges.*

## Task 1: Cloning repository which deploys a FortiWeb VM and a Web Server
This lab is fully automated using [Terraform by Hashicorp](https://www.terraform.io/). Terraform is one of the most popular tools for managing cloud infrastructure as code (IaC). While each cloud platform offers its own native tools for IaC, Terraform uses a broad open ecosystem of providers allowing creating and managing resources in any platform equipped with a proper API. In this lab you will use [google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) (by Google) to manage resources in Google Cloud.

All code for this lab is hosted in a public git repository. To use it start by creating a local copy of its contents.

1.	Run the following command in your Cloud Shell to clone the git repository contents:

    ```
    git clone https://github.com/fortinetsolutions/terraform-modules.git
    ```
2.	Change current working directory to **GCP/qwiklabs/fortiweb** inside the cloned repository:

    ```
    cd terraform-modules/GCP/qwiklabs/fortiweb
    ```
3. In the **Cloud Shell Editor** part of your Cloud Shell tab choose **File > Open** from the top menu and open the **terraform-modules/qwiklabs/fortiweb** folder. Cloud Shell Editor will be useful to navigate, review and edit terraform code during this lab.

For the Terraform, each directory containing **.tf** files is a module. A directory in which you run terraform command is the *root module* and can contain *submodules*. In this lab you will deploy a root module: **fortiweb** containing submodules.


## Task 2: Deploying Web Server
Using **fortiweb** module you will deploy a FortiWeb and an nginx web server in a VPC .

### Customizing deployment through variables
Before deploying the **fortiweb** module you have an opportunity to customize it. The module expects an input variable indicating the region to use.

As this lab is restricted to use us-central1 region, provide name the region in the **fortiweb/terraform.tfvars** file:
`region = "us-central1"`

You also have to indicate the GCP project to deploy to by setting `project` variable in **fortiweb/terraform.tfvars** to the name of your qwiklabs project indicated as **GCP Project ID** in the **Lab Details** panel. 

### Web Server deployment
Web Server deployment consists of 3 steps. Execute them now as described below:

1.	In **fortiweb** directory initialize terraform using command

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
    >*Note: It is recommended not to have an External IP for this Web Server. 

## Task 3: Connect to FortiWeb & WebServer
In this step you will connect to the FortiWeb

![FortiWeb Login Page](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_login.png)

1.  Once you login you will be at the FortiWeb Dashboard setup

![FortiWeb Dashboard](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_dashboard.png)


## Task 4: Check Connectivity to WebServer


1.  Click on CLI Console to check the connectivity to the web server

![FortiWeb CLI console](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_cli_console.png)


2.  Check connectivity to the web server via CLI-Console.
    Ping Internal IP of the WebServer

![FortiWeb Connectivity](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_connectivity_ws.png)

    ```  
    execute ping 10.10.3.2
    ```

## Task 5: Create Server Pool

1.  Navigate to Server Objects

    ```  
    Server Objects >> Server >> Server Pool >> Create new
    ```

![FortiWeb Server Pool](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_server_object_new.png)

2.  Input information as shown below. Select the Server Balance option for Server Health check option to appear. Click OK.

![FortiWeb Server Pool](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_server_pool_ok.png)

3.  Once click OK in the above step the greyed out Create new button should now appear to create the Server object.

    ```  
    Create New 
    ```

![FortiWeb Server Object](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_server_object_1.png)

4. Now enter the IP address of your application server in this case it is the IP address of Apache Server, the port number the pool member/application server listens for connections. 

    ```  
    Click OK once you enter the information. 
    ```

![FortiWeb Server Pool](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_server_object_2.png)

![FortiWeb Server Object](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_server_object_3.png)


## Task 6:  Create Virtual Server and IP

1. Now we will need to create the Virtual Server IP on which the Traffic destined for server pool member arrives. When FortiWeb receives traffic destined for a Virtual server it can then forward to its pool members. 

![FortiWeb Virtual Server](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_virtual_server.png)

2. Enter the name for the Virtual Server and click OK

![FortiWeb Virtual Server](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_virtual_server_ok.png)

3. Click Create new as shown below to now create Virtual Server item.

![FortiWeb Virtual Server Item](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_virtual_server_item.png)

4. Virtual Server item can be an IP address of the interface or an IP other than the interface. In this case we will use the interface IP - Turn on the Radio button for “use interface IP”, a drop down with interfaces will appear. Select Port1 as the interface for this Virtual Server item and click OK.

![FortiWeb Virtual Server Item Interface](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_virtual_server_item_interface.png)

5. The Virtual Server for the Apache Server is now using the IP address of the Port1 Interface. 

![FortiWeb Virtual Server Item Interface IP](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fweb_virtual_server_item_interface_ip.png)


## Task 7:  Create Web Protection Profile  

1. We will now create a Policy to apply a protection profile to protect our application Server. Before creating a policy let’s look at few default protection profiles that FortiWeb is configured with. The Inline Standard protection profile consists of signatures to protect against SQL injection, XSS and other generic attacks.

    ```  
    Navigate to Policy >> Web Protection Profile
    ```

![FortiWeb Policy Web Protection Profile](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_policy_wpp.png)

>*Note: You can create your custom Protection profile as well.*

2. Now let’s create a Server policy. Input Name for the server policy, Select the Virtual Server, Server pool which we created in the earlier steps from the drop down and finally Select the HTTP service. In this step we are not attaching the Protection profile. Click OK.

![FortiWeb Policy Web Protection Profile](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_policy_wpp_2.png)

![FortiWeb Policy Web Protection Profile](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_policy_wpp_3.png)

## Task 8: Perform an attack

1. Now let’s Navigate to the browser and type the Public IP assigned to your FortiWeb instance to get to the web browser. http://FortiWebIP

![FortiWeb Policy Web Server](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_webserver.png)

2. Let’s perform a SQLi attack. To perform a SQLi attack append ?name=' OR 'x'='x to your URL. 

    ```
    For example: http://34.135.252.181/?name=' OR 'x'='x
    ```
    >*Note: The attack will go through.*

![FortiWeb Policy Web Server](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_webserver_success.png)

## Task 9:  Protect WebServer from Attack

1. We will now attach the FortiWeb protection profile.

Click the dropdown and attack inline standard protection. Click OK.

![FortiWeb Policy Web Protection Profile](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_policy_wpp_1.png)

![FortiWeb Policy Web Protection Profile](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_policy_wpp_4.png)

2. Repeat the same step to perform SQLi attack in the browser. 

    ```
    For example: http://34.135.252.181/?name=' OR 'x'='x
    ```
    >*Note: You will see that FortiWeb now blocks the SQLi attack.*

![FortiWeb Policy Web Server](https://raw.githubusercontent.com/fortinetsolutions/terraform-modules/master/GCP/qwiklabs/fortiweb/instructions/img/fortiweb_webserver_blocked.png)

### Congratulations!
Congratulations, you have successfully configured the VPC Peering. The skills and concepts you have learned can help you build secure environments leveraging network security experience of FortiGuard Labs combined with cloud-native workflows, eliminating the requirement to interactively log into the firewall management console.

##  Clean-up
To revert changes and remove resources you created in this lab do the following:

1.	To delete the demo application: in the Cloud Shell, issue the following command while in **GCP/qwiklabs/fortiweb** directory:  

    ```
    terraform destroy
    ```

    confirm your decision to delete the resources by typing `yes`

2. Click **End Lab** button in **Lab Details** panel.
