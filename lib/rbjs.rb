require "rbjs/version"
require 'rails'
require 'active_support'
require 'json'

module Rbjs
  
  class Railtie < Rails::Railtie
    initializer 'rbjs.setup' do
      ActiveSupport.on_load(:action_controller) do
        require 'rbjs/setup_action_controller'
      end
      ActiveSupport.on_load(:action_view) do
        require 'rbjs/setup_action_view'
      end
    end
  end

  class Root
    def initialize view_context, &block
      @_view_context = view_context and
      for instance_var, val in view_context.assigns
        instance_variable_set '@'+instance_var, val
      end
      if @_view_context.respond_to?(:helpers) && @_view_context.helpers
        extend @_view_context.helpers
      end
      @_block = block
      @_called_statements = []
    end
    
    def evaluate function_parameters = nil
      instance_exec *function_parameters, &@_block
      @_called_statements.map(&:last_of_chain).reject(&:is_argument).map(&:to_s).join(";\n")
    end
    
    def method_missing name, *args, &block
      if @_view_context and @_view_context.respond_to?(name)
        @_view_context.send name, *args, &block
      else
        statement = Statement.new name, @_view_context, *args, &block
        @_called_statements << statement
        statement
      end
    end
    alias_method :const_missing, :method_missing
    
    def << line
      @_called_statements << Statement.new(line)
    end
  end
  
  class Statement
    attr_accessor :parent_statement
    attr_accessor :child_statement
    attr_accessor :is_argument
    
    def initialize name, view_context = nil, *args, &block
      @name = name.to_s.gsub '!', '()'
      @_view_context = view_context
      args << block if block_given?
      @arguments = args.map{|arg| to_argument(arg)}
    end
    
    def method_missing name, *args, &block
      statement = Statement.new name, @_view_context, *args, &block
      statement.parent_statement = self
      self.child_statement = statement
      statement
    end
    
    def to_s
      if ['+','-','*','/'].include?(@name)
        @parent_statement.to_s + @name + @arguments.first
      elsif @name == '[]='
        @parent_statement.to_s + '[' + @arguments.first + ']= ' + @arguments.last
      elsif @name == '[]'
        @parent_statement.to_s + '[' + @arguments.first + ']'
      elsif @parent_statement
        parent_str = @parent_statement.to_s
        parent_str += parent_str == 'var' ? ' ' : '.'
        parent_str + @name + argument_list
      else
        @name + argument_list
      end        
    end
    
    def argument_list
      return '' if @arguments.empty?
      '(' + @arguments.join(', ') + ')'
    end
    
    def last_of_chain
      if @child_statement
        @child_statement.last_of_chain
      else
        self
      end
    end
    
    def to_argument arg
      if arg.is_a?(Statement)
        arg.is_argument = true
        arg.to_s
      elsif arg.is_a?(ArgumentProxy)
        arg.to_s
      elsif arg.is_a?(Array)
        '['+arg.map{|val|to_argument(val)}.join(', ')+']'
      elsif arg.is_a?(Hash)
        '{'+arg.map{|key, val|to_argument(key)+': '+to_argument(val)}.join(',')+'}'
      elsif arg.is_a?(Proc)
        root = Root.new(@_view_context, &arg)
        function_parameters = []
        function_parameter_names = []
        for param in arg.parameters
          function_parameter_names << param[1]
          function_parameters << ArgumentProxy.new(root, param[1])
        end
        "function(#{function_parameter_names.join ', '}) {\n#{root.evaluate function_parameters}}"
      else
        arg.to_json
      end
    end
  end

  class ArgumentProxy
    def initialize root, name
      @root = root
      @name = name
    end

    def method_missing name, *args, &block
      statement = @root.send(@name)
      statement.send name, *args, &block
    end

    def to_s
      @name
    end
  end

end