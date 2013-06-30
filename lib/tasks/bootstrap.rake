namespace :db do

  # you can load a single fixture by passing part of a filename like this:
  #   rake db:bootstrap[00]
  
  desc "Loads initial database models for the current environment."
  task :bootstrap, :filepart, :needs => :environment do |task, args|
    filepart = args['filepart'] || ""
    Dir[File.join(RAILS_ROOT, 'db', 'bootstrap', "#{filepart}*.rb")].sort.each { |fixture| 
      puts "Loading #{fixture}"
      load fixture 
    }
    Dir[File.join(RAILS_ROOT, 'db', 'bootstrap', RAILS_ENV, "#{filepart}*.rb")].sort.each { |fixture| 
      puts "Loading #{fixture}"
      load fixture 
    }
  end

end