require 'tilt/template'

module Rbjs
  
  class RbjsTemplate < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def evaluate scope, locals, &block
      return Rbjs::Root.new(scope, &block).evaluate if block_given?
      super
    end

    def precompiled_template locals
      "Rbjs::Root.new self do\n#{@data}\nend.evaluate"
    end

    def prepare
     # Nothing to do here.
    end
  end

  Tilt.register 'rbjs', RbjsTemplate

end
