namespace :app do
  # example call:
  # UNTIL="16:00 MST" REASON="a database upgrade" cap disable_web
  desc "Generate a maintenance.html to disable requests to the application."
  task :disable, :roles => :web do
    remote_path = "#{shared_path}/system/maintenance.html"
    on_rollback { run "rm #{remote_path}" }
    template = File.read(disable_template)
    deadline, reason = ENV["UNTIL"], ENV["REASON"]
    maintenance = ERB.new(template).result(binding)
    put maintenance, "#{remote_path}", :mode => 0644
  end

  desc "Re-enable the web server by deleting any maintenance file."
  task :enable, :roles => :web do
    run "rm #{shared_path}/system/maintenance.html"
  end

end
