class MediaMail < ActiveRecord::Base
    
  def self.get_rate(weight)
    media_mail = MediaMail.last
    weight += 1 if weight < 1
    rate = Money.new((weight.to_i) * media_mail.factor) + Money.new(media_mail.starting_point)
  end
  
end
