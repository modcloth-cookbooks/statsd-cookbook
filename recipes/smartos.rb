#
# Cookbook Name:: statsd
# Recipe:: smartos
#
# Copyright 2011, ModCloth, Inc.
#

include_recipe "smf"

smf "statsd" do
	user "statsd"
	start_command "#{node[:statsd][:node_executable]} #{node[:statsd][:path]}/stats.js " << 
		"#{node[:statsd][:config]} 2>&1 >> #{node[:statsd][:log_file]} &"
	stop_command ":kill -SIGINT"
	working_directory node[:statsd][:path]
end

service "statsd" do
  supports :restart => true, :start => true, :stop => true
end