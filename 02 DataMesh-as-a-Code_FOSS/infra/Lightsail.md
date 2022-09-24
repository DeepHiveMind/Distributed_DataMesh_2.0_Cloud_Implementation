# AWS Lightsail

Navigate to the [AWS Console](http://console.aws.amazon.com) and login with your user. Click on the [Lightsail service](https://lightsail.aws.amazon.com/ls/webapp/home/instances).

![Alt Image Text](./images/lightsail-homepage.png "Lightsail Homepage")

## Provision instance

Click **Create instance** to navigate to the **Create an instance** dialog. 

![Alt Image Text](./images/lightsail-create-instance-1.png "Lightsail Homepage")

Optionally change the **Instance Location** to a AWS region of your liking.
Keep **Linux/Unix** for the **Select a platform** and click on **OS Only** and select **Ubuntu 18.04 LTS** for the **Select a blueprint**. 

![Alt Image Text](./images/lightsail-create-instance-2.png "Lightsail Homepage")

Scroll down to **Launch script** and add the following script 

```
export GITHUB_PROJECT=data-mesh-demo
export GITHUB_OWNER=trivadispf
export DATAPLATFORM_HOME=infra/platys
export DOCKER_COMPOSE_VERSION=1.29.2
export PLATYS_VERSION=2.4.2
export NETWORK_NAME=eth0
export USERNAME=ubuntu
export PASSWORD=ubuntu

# Prepare Environment Variables 
export PUBLIC_IP=$(curl ipinfo.io/ip)
export DOCKER_HOST_IP=$(ip addr show ${NETWORK_NAME} | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# allow login by password
sudo sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo "${USERNAME}:${PASSWORD}"|chpasswd
sudo service sshd restart

# add alias "dataplatform" to /etc/hosts
echo "$DOCKER_HOST_IP     dataplatform" | sudo tee -a /etc/hosts

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
apt-get install -y docker-ce
sudo usermod -aG docker $USERNAME

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Platys
sudo curl -L "https://github.com/TrivadisPF/platys/releases/download/${PLATYS_VERSION}/platys_${PLATYS_VERSION}_linux_x86_64.tar.gz" -o /tmp/platys.tar.gz
tar zvxf /tmp/platys.tar.gz 
sudo mv platys /usr/local/bin/
sudo chown root:root /usr/local/bin/platys
sudo rm README.md

# Install various Utilities
sudo apt-get install -y curl jq kafkacat

# needed for elasticsearch
sudo sysctl -w vm.max_map_count=262144   

# Get the project
cd /home/${USERNAME} 
git clone https://github.com/${GITHUB_OWNER}/${GITHUB_PROJECT}
chown -R ${USERNAME}:${USERNAME} ${GITHUB_PROJECT}

cd /home/${USERNAME}/${GITHUB_PROJECT}/${DATAPLATFORM_HOME}

# Prepare Environment Variables into .bash_profile file
printf "export PUBLIC_IP=$PUBLIC_IP\n" >> /home/$USERNAME/.bash_profile
printf "export DOCKER_HOST_IP=$DOCKER_HOST_IP\n" >> /home/$USERNAME/.bash_profile
printf "export DATAPLATFORM_HOME=$PWD\n" >> /home/$USERNAME/.bash_profile
printf "\n" >> /home/$USERNAME/.bash_profile
sudo chown ${USERNAME}:${USERNAME} /home/$USERNAME/.bash_profile

# Startup Environment
sudo -E docker-compose up -d
```

into the **Launch Script** edit field
 
![Alt Image Text](./images/lightsail-create-instance-3.png "Lightsail Homepage")

Click on **Change SSH key pair** and leave the **Default** selected and then click on **Download** and save the file to a convenient location on your machine. Under **Choose your instance plan** click on the arrow on the right and select the **16 GB** instance.   

Under **Identify your instance** enter **Ubuntu-Hadoop-1** into the edit field. 

![Alt Image Text](./images/lightsail-create-instance-4.png "Lightsail Homepage")

Click on **Create Instance** to start provisioning the instance. 

The new instance will show up in the Instances list on the Lightsail homepage. 

![Alt Image Text](./images/lightsail-image-started.png "Lightsail Homepage")

Click on the instance to navigate to the image details page. On the right you can find the Public IP address **18.196.124.212** of the newly created instance.

![Alt Image Text](./images/lightsail-image-details.png "Lightsail Homepage")

Click **Connect using SSH** to open the console and enter the following command to watch the log file of the init script.

```
tail -f /var/log/cloud-init-output.log --lines 1000
```

The initialisation is finished when you see the `Creating xxxxx .... done` lines after all the docker images have been downloaded, which takes a couple of minutes. 

![Alt Image Text](./images/lightsail-create-instance-log-file.png "Lightsail Homepage")

Optionally you can also SSH into the Lightsail instance using the **SSH key pair** you have downloaded above. For that open a terminal window (on Mac / Linux) or Putty (on Windows) and connect as ubuntu to the Public IP address of the instance.   

```
ssh -i LightsailDefaultKey-eu-central-1.pem ubuntu@18.196.124.212 
```

So with all services running, there is one last step to do. We have to configure the Firewall to allow traffic into the Lightsail instance. 

![Alt Image Text](./images/lightsail-image-networking.png "Lightsail Homepage")

Click on the **Networking** tab/link to navigate to the network settings and under **Firewall** click on ** **Add another**.
For simplicity reasons, we allow all TCP traffic by selecting **All TCP** on port range **0 - 65535** and then click **Save**. 

![Alt Image Text](./images/lightsail-image-networking-add-firewall-rule.png "Lightsail Homepage")

Your instance is now ready to use. Complete the post installation steps documented the [here](README.md).

## Stop an Instance

To stop the instance, navigate to the instance overview and click on the drop-down menu and select **Stop**. 

![Alt Image Text](./images/lightsail-stop-instance.png "Lightsail Homepage")

Click on **Stop** to confirm stopping the instance. 

![Alt Image Text](./images/lightsail-stop-instance-confirm.png "Lightsail Homepage")

A stopped instance will still incur charges, you have to delete the instance completely to stop charges. 


## Create a snapshot of an Instance

When an instance is stopped, you can create a snapshot, which you can keep, even if later drop the instance to reduce costs.

![Alt Image Text](./images/lightsail-image-create-snapshot.png "Lightsail Homepage")

You can always recreate an instance based on a snapshot. 

# De-provision the environment

To stop the environment, execute the following command:

```
docker-compose stop
```

after that it can be re-started using `docker-compose start`.

To stop and remove all running container, execute the following command:

```
docker-compose down
```

