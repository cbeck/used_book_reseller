class Message < ActiveRecord::Base
  attr_accessor :subject, :body
  
  validates_presence_of :subject, :body
  
  def initialize(params)
    @subject = params[:subject]
    @body = params[:body]
  end
  
end
