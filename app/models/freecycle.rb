class Freecycle < ActiveRecord::Base
  belongs_to :member
  belongs_to :metro_area
  
  acts_as_ferret :fields => [:name, :description]
  
  def short_description
    (description.size > 100) ? "%-05.100s..." % description : description
  end
end
