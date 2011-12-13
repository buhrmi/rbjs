module Rbjs
  Sinatra.helpers do
    def js content=nil, &block
      content_type 'application/javascript'
      if block_given?
        render :rbjs, '', &block
      else
        render :rbjs, content
      end
    end
  end
end