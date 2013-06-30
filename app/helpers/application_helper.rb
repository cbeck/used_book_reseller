# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def section_title
    controller.controller_name.capitalize + " Administration"
  end
  
  def page_title
    controller.controller_name.capitalize + " " + controller.action_name.capitalize
  end
  
  def hidden_div_if(condition, attributes = {})
    if condition
      attributes["style" ] = "display: none"
    end
      attrs = tag_options(attributes.stringify_keys)
      "<div #{attrs}>"
  end
  
  def render_sub_nav(sub_nav_items=nil, current_item=nil)
    output = ""
    unless sub_nav_items.blank?
      sub_nav_items.each {|sub_item| 
        sub_item.each {|item, url|
          sn_id = item.gsub(/[\s+]/, '_')
          output += "<li id='sub_nav_#{sn_id}'"
          output += " class='current'" unless current_item.nil? || current_item != sn_id
          output += ">#{link_to item, url}</li>"
        }        
      }      
    end
    output
  end
  
  def render_trail(active_tab=nil, current_item=nil)
    output = ""
    output += " | #{active_tab.gsub(/(_tab)/, " ").capitalize}" unless active_tab.blank?
    output += " | #{current_item.gsub(/(_)/, " ").capitalize}" unless current_item.blank?
    output
  end
  
  def render_price(amount)
    (amount.is_a?(Money)) ? "#{amount.format} ppd*" : "#{number_to_currency(amount)} ppd*"
  end
  
  
  # A helper to show flash messages as an ajax messenger be it as a notice or error (if warning). Options include the keys to test
  # the id of the messages client, and whether to textilize the data.
  def show_ajax_flash_messages(options={}, page=nil)
     options = { :keys => [:warning, :notice, :message],
                  :id => 'messages',
                  :textilize => false,
                  :wrap_js => true}.merge(options)
      out = []
      message = nil
      options[:keys].each do |key|
        next unless flash[key]
        [flash[key]].flatten.compact.each do |msg|
          text = (options[:textilize] ? textilize(msg) : msg)
          message = text
        end
        type = "notice"
        type = "error" if key == :warning
        if !message.nil?
          if page.nil?
            out << "<script type=\"text/javascript\"> " if options[:wrap_js]
            out << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
            out << "</script>" if options[:wrap_js]
          else
            page << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
          end
        end
        flash.discard(key)
      end
      if page.nil?
        return nil if out.empty? 
        return out
      end
  end
  
  def google_analytics(tracker)
    @@urchin ||= <<-EOS
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("#{tracker}");
      pageTracker._trackPageview();
      } catch(err) {}</script>
    EOS
    @@urchin if ENV['RAILS_ENV'] == 'production' && !(logged_in? && current_member.is_admin?)
  end
  
  def codify(name)
    name.gsub(/[\s]/, '').underscore
  end
  
  def is_ie_6?
    !request.env['HTTP_USER_AGENT'].nil? && request.env['HTTP_USER_AGENT'].index('MSIE 6')
  end
  
  def disable_enter_key
    { :onKeyPress=>'return disableEnterKey(event)' }
  end
  
end
