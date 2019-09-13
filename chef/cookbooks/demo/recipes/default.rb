#
# Cookbook:: demo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#package "nginx"

#service "nginx" do
#  action [:enable, :start]
#end

file "/Users/carlotaguinod/Downloads/chef-demo/index.html" do
  content "<h1>Hello, Chef!</h1>"
  action :create
  not_if { ::File.exists?("/Users/carlotaguinod/Downloads/chef-demo/index.html") }
end