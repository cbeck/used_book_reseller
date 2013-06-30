module ActiveRecord
  class Base
      def self.count_since(time_ago)
        count(:conditions => ['created_at > ?', time_ago])
      end
  end
end
