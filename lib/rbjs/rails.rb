require 'rails'

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
end