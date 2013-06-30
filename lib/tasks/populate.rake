namespace :db do

  # you can load a single fixture by passing part of a filename like this:
  #   rake db:populate[00]
  
  desc "Loads initial database models for the current environment."
  task :populate, :filepart, :needs => :environment do |task, args|
    filepart = args['filepart'] || ""
    Dir[File.join(RAILS_ROOT, 'db', 'fixtures', "#{filepart}*.rb")].sort.each { |fixture| 
      puts "Loading #{fixture}"
      load fixture 
    }
    Dir[File.join(RAILS_ROOT, 'db', 'fixtures', RAILS_ENV, "#{filepart}*.rb")].sort.each { |fixture| 
      puts "Loading #{fixture}"
      load fixture 
    }
  end

  # desc "Load seed fixtures (from db/fixtures) into the current environment's database." 
  # task :seed => :environment do
  #   require 'active_record/fixtures'
  #   Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
  #     Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
  #   end
  # end

end
