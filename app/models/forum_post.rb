class ForumPost < ActiveRecord::Base
  acts_as_nested_set :scope => :root
  belongs_to :forum
  belongs_to :member
  
  validates_length_of :subject, :within => 1..255
  
  acts_as_nested_set :scope => :root

  def before_create
    # Update the child object with its parents attrs
    unless self[:parent_id].to_i.zero?
      self[:depth] = parent[:depth].to_i + 1
      self[:root_id] = parent[:root_id].to_i
    end
  end

  def after_create
    # Update the parent root_id with its id
    if self[:parent_id].to_i.zero?
      self[:root_id] = self[:id]
      self.save
    else
      parent.add_child self
    end
  end

  def parent
    @parent ||= self.class.find(self[:parent_id])
  end
  
end
