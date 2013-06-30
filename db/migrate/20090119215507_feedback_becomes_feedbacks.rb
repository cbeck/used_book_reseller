class FeedbackBecomesFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks, :force => true do |t|
      t.integer :line_item_id
      t.integer :rating
      t.text :comment
      t.timestamps
    end
    
    drop_table :feedback
  end

  def self.down
    # buwahahahah - one way ticket to paradise here! (Rails routes chokes on @feedback in forms if you make it singular)
  end
end
