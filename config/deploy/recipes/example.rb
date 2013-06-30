namespace :deploy do
  
  desc "Serve an example merb app with passenger"
  task :example_app do
    app_name = "example"
    
    run <<-CMD
echo "127.0.0.1 localhost #{instance_url}" >> /etc/hosts &&
gem i merb --no-ri --no-rdoc &&
gem i hpricot --no-ri --no-rdoc &&
gem i memcache-client --no-ri --no-rdoc &&
cd /var/www &&
merb-gen app #{app_name} --flat &&
mkdir #{app_name}/public #{app_name}/tmp #{app_name}/log &&
echo "#{RACK_CONFIG}" >> #{app_name}/config.ru &&
echo "<VirtualHost *>" >> /etc/apache2/sites-available/#{app_name} &&
echo "    ServerName #{instance_url}" >> /etc/apache2/sites-available/#{app_name} &&
echo "    DocumentRoot /var/www/#{app_name}/public" >> /etc/apache2/sites-available/#{app_name} &&
echo "    ErrorLog /var/www/#{app_name}/log/error.log" >> /etc/apache2/sites-available/#{app_name} &&
echo "</VirtualHost>" >> /etc/apache2/sites-available/#{app_name} &&
cd /etc/apache2/sites-available &&
a2ensite #{app_name} &&
/etc/init.d/apache2 restart
    CMD
  end
end

RACK_CONFIG = %{
require 'rubygems';
require 'merb-core';

Merb::Config.setup(:merb_root   => '.', :environment => ENV['RACK_ENV']);
Merb.environment = Merb::Config[:environment];
Merb.root = Merb::Config[:merb_root];
Merb::BootLoader.run;
\n
run Merb::Rack::Application.new
}