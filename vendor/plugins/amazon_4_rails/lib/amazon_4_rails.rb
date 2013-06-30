require 'amazon/ecs'
# Amazon4Rails

module ThirdDay
  module Amazon4Rails
    
    def self.included(mod)
      mod.extend(ClassMethods)
    end
    
    
    module ClassMethods
      def acts_as_amazonable
        class_eval do
          extend ThirdDay::Amazon4Rails::SingletonMethods
        end
      end
      
      # Provides for mapping model attributes to attributes of the returned amazon-ecs result 
      # object. An optional parameter allows for certain attributes which may occur multiple
      # times (eg. the authors of a book) to be returned as a single string joined with a provided
      # parameter
      #
      # eg.
      #   maps_to_amazon_attribute :authorlist => 'authors', :combine => ';'
      #   maps_to_amazon_attribute :title => 'product_name'
      #   maps_to_amazon_attribute :isbn => 'asin'
      #
      def maps_to_amazon_attribute(args = {})
        if @amazon_mappings.nil?
          @amazon_mappings = Hash.new
          @amazon_join_mappings = Hash.new
        end

        joiner = args.delete(:combine) if args[:combine]
        args.each do |key, value|
          if joiner
            @amazon_join_mappings[key] = [value, joiner]
          else
            @amazon_mappings[key] = value
          end
        end
      end
      
      def set_amazon_options(args = {})
        if @amazon_options.nil?
          @amazon_options = Hash.new
        end
        
        args.each do |key, value|
          @amazon_options[key] = value
        end        
      end
    end
    
    module SingletonMethods
      def load_from_amazon(asin_value, dev_key = '1MZTQGBA4YWAFHSTG4R2', associates_id = 'thirddayweb-20') 
        begin
          # default options; will be camelized and converted 
          # to REST request parameters.
          opts = {:aWS_access_key_id => dev_key, :response_group => 'Medium', :associates_id => associates_id}
          opts = opts.merge(@amazon_options) if @amazon_options
          Amazon::Ecs.options = opts
          res = Amazon::Ecs.item_lookup(asin_value)
          # some common response object methods
          # res.is_valid_request?
          # res.has_error?
          # res.error
          # res.total_pages
          # res.total_results
          # res.item_page

          # puts res.inspect
          create_instance_from_amazon(res.items[0])
        rescue
          raise
          return
        end
      end
      
      #   Model.load_from_amazon!(asin_value, dev_key, associates_id)
      #
      # will load the model from an amazon result (or return empty if the product couldn't
      # be found) and call the save method on the model object.
      def load_from_amazon!(asin_value, dev_key = '1MZTQGBA4YWAFHSTG4R2', associates_id = 'thirddayweb-20')
        result = self.load_from_amazon(asin_value, dev_key, associates_id)
        if result
          result.save
          return result
        end
      end
      
      private
      def create_instance_from_amazon(item)
        newbie = self.new
        @amazon_mappings.each do |key, value|
          newbie.send key.to_s + '=', item.get(value)
        end
        @amazon_join_mappings.each do |key, value|
          newbie.send key.to_s + '=', item.get(value[0]).join(value[1])
        end
        # retrieve string value using XML path
        # asin = item.get('asin')
        # title = item.get('itemattributes/title')

        # or return Amazon::Element instance
        # atts = item.search_and_convert('itemattributes')

        # get title as a string 
        # @product.title = atts.get('title')
        # @product.publisher_name = atts.get('manufacturer')
        # @current_list_price = atts.get('listprice/formattedprice')


        # get only returns the first element of an array
        # atts.get('author')            # 'Author 1'

        # to retrieve an array
        # atts.get_array('author')    # ['Author 1', 'Author 2', ...]

        # to retrieve a hash of children text values
        # item.get_hash('smallimage') # {:url => ..., :width => ..., :height => ...}

        # '/' returns Hpricot::Elements array object, nil if not found
        # reviews = item/'editorialreview'
        # unless reviews.nil?
          # traverse through Hpricot elements
          # reviews.each do |review| 
            # Getting a hash value out of Hpricot element
            #Amazon::Element.get_hash(review) # [:source => ..., :content ==> ...]

            # Or to get unescaped HTML values
            #Amazon::Element.get_unescaped(review, 'source')
            #Amazon::Element.get_unescaped(review, 'content')

            # Or this way
            # el = Amazon::Element.new(review)
            # source = el.get_unescaped('source')
            # if source == "Book Description"
              # @product.description = el.get_unescaped('content') 
            # end          
          # end
        # end
        
        
        
        return newbie
      end
    end
    
    
  end  
end
  