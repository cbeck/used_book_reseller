namespace :tunnel do
  REMOTE_USER = "admin"
  REMOTE_HOST = "10.255.135.161"
  REMOTE_PORT = "8090"
  # LOCAL_HOST = "0.0.0.0"
  LOCAL_HOST = "localhost"
  LOCAL_PORT = "3000"
  
  desc "Start a reverse tunnel to develop from localhost."
  task "start" => "environment" do
    
    puts "======================================================"
    puts "Tunneling #{REMOTE_HOST}:#{REMOTE_PORT} to #{LOCAL_HOST}:#{LOCAL_PORT}"
          
    puts
    puts "NOTES:"
    puts "* ensure that you have Rails running on your local machine at port #{LOCAL_PORT}"
    puts "* once logged in to the tunnel, you can visit http://#{REMOTE_HOST}:#{REMOTE_PORT} to view your site"
    puts "* use ctrl-c to quit the tunnel"
    puts "* if you have problems creating the tunnel, you may need to add the following "
    puts "  to /etc/ssh/sshd_config on your server:\n"
    puts "    GatewayPorts clientspecified"
    puts "* if you have problems with #{REMOTE_HOST} timing out your ssh connection, add the following lines "
    puts "  to your '~/.ssh/config' file:\n"
    puts "    Host #{REMOTE_HOST}\n"
    puts "    ServerAliveInterval 120"
    puts "======================================================"
    # exec "ssh -nNT -g -R #{REMOTE_HOST}:#{REMOTE_PORT}:#{LOCAL_HOST}:#{LOCAL_PORT} #{REMOTE_USER}@#{REMOTE_HOST}"
    exec "ssh admin@netphase.com -NR #{REMOTE_HOST}:#{REMOTE_PORT}:#{LOCAL_HOST}:#{LOCAL_PORT}"
    
  end
  
  desc "Check if reverse tunnel is running"
  task "status" => "environment" do
    if `ssh #{REMOTE_USER}@#{REMOTE_HOST} netstat -an | egrep "tcp.*:#{REMOTE_PORT}.*LISTEN" | wc`.to_i > 0
      puts "Tunnel still running"
    else
      puts "Tunnel is down"
    end
  end
      
end