#!/bin/bash
# Remove elasticsearch
sudo apt-get remove --purge elasticsearch

# Import Elasticsearch GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Install required package for HTTPS repository access
sudo apt-get install apt-transport-https -y

# Add Elasticsearch repository
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

# Update apt package lists and install Elasticsearch
sudo apt-get update
sudo apt-get install elasticsearch -y

# Remove default network configurations
sudo sed -i 's/#node.name/node.name/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/network.host:/d' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/discovery.seed_hosts:/d' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/cluster.initial_master_nodes:/d' /etc/elasticsearch/elasticsearch.yml

# Add desired network configurations
sudo tee -a /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOT
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1"]
cluster.initial_master_nodes: ["node-1"]
EOT

# Enable and start Elasticsearch service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

