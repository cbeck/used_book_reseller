namespace :mod_rails do
  desc "Restart the application altering tmp/restart.txt for mod_rails."
    task :restart, :roles => :app do
      run "touch  #{release_path}/tmp/restart.txt"
    end
  end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
end

after :deploy, "mod_rails:restart"
