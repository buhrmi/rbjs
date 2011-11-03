module Rbjs
  module ControllerExtensions
    def render *args, &block
      if args.first == :js
        self.content_type  = Mime::JS
        self.response_body = Rbjs::Root.new(view_context, &block).evaluate
      else
        super
      end
    end
  end
  ActionController::Base.send :include, ControllerExtensions
end
