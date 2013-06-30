# Contents of init.rb
require 'amazon_4_rails'
ActiveRecord::Base.send :include, ThirdDay::Amazon4Rails
