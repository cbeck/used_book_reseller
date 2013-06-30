class CommunityController < ApplicationController
  before_filter :show_members
  
  def index
    @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    if params[:id]
      @initial = params[:id]
      members = Member.find(:all, :conditions => ["login like ?", @initial+'%'], :order => "login" )
    else
      members = Member.find(:all, :order => "login" )
    end
    @members = members.reject {|m| m.profile.nil? || !m.profile.active?}
  end

  def browse
  end

  def search
  end
  
  private 
  
  def show_members
    @show_members = true
  end

end
