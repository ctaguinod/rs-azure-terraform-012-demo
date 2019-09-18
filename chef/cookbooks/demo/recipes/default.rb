#
# Cookbook:: demo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#package "nginx"

#service "nginx" do
#  action [:enable, :start]
#end

# Test create file to local disk
#file "/chef-demo/index-from-file.html" do
#  content "<h1>Hello, Chef!</h1>"
#  action :create
#  not_if { ::File.exists?("/chef-demo/index-from-file.html") }
#end

#include_recipe 'iis::default'
#include_recipe 'azure_file::default'

# Test copy folder from Azure blob to local
#azure_file 'c:\\inetpub\\wwwroot\\index-from-azure-blob.html' do
#  storage_account 'storageAccountHere'
#  access_key 'accessKeyHere'
#  container 'containerHere'
#  remote_path 'index-from-azure-blob.html'
#end