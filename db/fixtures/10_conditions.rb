Condition.enumeration_model_updates_permitted = true
Condition.destroy_all
newbie = Condition.create :name => 'new', :description => "Brand spanking new", :requires_comment => false
like_new = Condition.create :name => 'like_new', :description => "You cannot tell it is used", :requires_comment => false
minor = Condition.create :name => 'minor', :description => "Minor wear", :requires_comment => false
average = Condition.create :name => 'average', :description => "Average wear", :requires_comment => false
well_loved = Condition.create :name => 'loved', :description => "Well loved (see comments)", :requires_comment => true
ragged = Condition.create :name => 'ragged', :description => "Seen better days (see comments)", :requires_comment => true




