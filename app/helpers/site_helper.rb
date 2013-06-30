module SiteHelper
  def path_with_filter(filter)
    url = request.request_uri.gsub(/&?(filter=)\w+/, '')
    url += "?" unless url.include? '?'
    url += "&filter=#{filter}"
  end    
end