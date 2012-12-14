#
# Cookbook Name:: statsd
# Recipe:: default
#
# Copyright 2011, Librato, Inc.
#

case node[:platform]
when "debian", "ubuntu"
  include_recipe "nodejs"
  include_recipe "git"
end

git node[:statsd][:path] do
  repository node[:statsd][:repo]
  revision node[:statsd][:revision]
  action :sync
end

execute "install dependencies" do
  command "npm install -d"
  cwd node[:statsd][:path]
end

backends = []

if node[:statsd][:graphite_enabled]
  backends << "./backends/graphite"
end

node[:statsd][:backends].each do |k, v|
  if v
    name = "#{k}@#{v}"
  else
    name= k
  end

  execute "install npm module #{name}" do
    command "npm install #{name}"
    cwd node[:statsd][:path]
  end

  backends << k
end

directory "/etc/statsd" do
  action :create
end

user "statsd" do
  comment "statsd"
  system true
  shell "/bin/false"
end

# Define services
case node[:platform]
  when "debian", "ubuntu"
    include_recipe "statsd::debian"
  when "smartos"
    include_recipe "statsd::smartos"
end

template node[:statsd][:config] do
  source "config.js.erb"
  mode 0644

  config_hash = {
    :flushInterval => node[:statsd][:flush_interval_msecs],
    :port => node[:statsd][:port],
    :backends => backends
  }.merge(node[:statsd][:extra_config])

  if node[:statsd][:graphite_enabled]
    config_hash[:graphitePort] = node[:statsd][:graphite_port]
    config_hash[:graphiteHost] = node[:statsd][:graphite_host]
  end

  if node[:statsd][:gossip_girl_enabled]
    config_hash[:gossip_girl] = [
      {
        :host => node[:statsd][:gossip_girl_host],
        :port => node[:statsd][:gossip_girl_port]
      }
    ]
  end

  variables(:config_hash => config_hash)

  notifies :restart, resources(:service => "statsd")
end

bash "create_log_file" do
  code <<EOH
touch #{node[:statsd][:log_file]} && chown statsd #{node[:statsd][:log_file]}
EOH
  not_if {File.exist?(node[:statsd][:log_file])}
end

service "statsd" do
  action [ :enable, :start ]
end
