
namespace :server do
  desc "Restart mod_rails server"
  task :restart do
    `touch tmp/restart.txt`
  end
end