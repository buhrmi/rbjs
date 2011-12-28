module Rbjs
  module Helpers
    def rbjs content=nil, &block
      content_type 'application/javascript'
      if block_given?
        render :rbjs, '', &block
      else
        render :rbjs, content
      end
    end
  end
  Sinatra.helpers Helpers
  Sinatra::Base.helpers Helpers
end