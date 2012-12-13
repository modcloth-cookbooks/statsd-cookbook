#
# Cookbook Name:: statsd
# Recipe:: debian
#
# Copyright 2011, ModCloth, Inc.
#

directory "#{node[:statsd][:path]}/scripts" do
  action :create
end

template "#{node[:statsd][:path]}/scripts/start" do
  source "upstart.start.erb"
  mode 0755
  notifies :restart, resources(:service => "statsd")
end

cookbook_file "/etc/init/statsd.conf" do
  source "upstart.conf"
  mode 0644
  notifies :restart, resources(:service => "statsd")
end

service "statsd" do
  provider Chef::Provider::Service::Upstart

  restart_command "stop statsd; start statsd"
  start_command "start statsd"
  stop_command "stop statsd"

  supports :restart => true, :start => true, :stop => true
end