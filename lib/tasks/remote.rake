namespace :spec do
  Rake::TestTask.new(:remote => "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = 'spec/remote/*_spec.rb'
    t.verbose = true
  end
  Rake::Task['spec:remote'].comment = "Test integration with remote services"
    
end