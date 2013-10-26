ActionView::Helpers::RenderingHelper.module_eval do
  def render_with_js(options = {}, locals = {}, &block)
    if options == :js
      Rbjs::Root.new(self.view_context, &block).evaluate
    else
      render_without_js(options, locals, &block)
    end
  end
  alias_method_chain :render, :js
end

module Rbjs
  class TemplateHandler

    class_attribute :default_format
    self.default_format = Mime::JS

    def call(template)
      "Rbjs::Root.new self do\n#{template.source}\nend.evaluate"
    end
  end
end

module Rbjs
  class Root
    # make respond_to?(:render) return true.
    def render(options = {}, locals = {}, &block)
      @_view_context.render(options, locals, &block) 
    end
  end
end

ActionView::Template.register_template_handler :rb, Rbjs::TemplateHandler.new