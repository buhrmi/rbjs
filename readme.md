## RJS IS BACK

### And it's better than ever before.

Rbjs is a modern RJS (remote javascript) extension for Rails 3 and up. It stands for **r**u**b**y**j**ava**s**cript. In contrast to prototype-rails, this library is designed to work with all javascript frameworks.

However, it is *not* a drop-in replacement for _.rjs_ -- it does things quite differently.

This is a very fresh gem. Feel free to test it while the documentation and tests are still being written. I've added some examples to this readme file. These should help you get a general idea of what this is about.

## Installation

Add the following line to your Gemfile

> gem 'rbjs'

and run _bundle install_ to install the gem and it's dependencies.

## Examples

### Take a look at a simple example:
  
    # controllers/greeter_controller.rb
    def greet_me
      render :js do
        window.alert "Hello, #{current_user_name}"
      end
    end

    # views/greeter/index.html.erb
    link_to "Hi there!", "/greeter/greet_me", :remote => true

### And a more complex example:

    # controllers/posts_controller.rb
    def refresh
      post = Post.find params[:id]
      render :js do
        post_element = jQuery(post.selector)
        post_element.html(render post)
        post_element.css(:opacity => 0).animate(:opacity => 1)
      end
    end

    # views/posts/index.html.erb
    link_to "Refresh Post", refresh_post_path(post), :remote => true

### You can also create .rbjs templates:

    # controllers/posts_controller.rb
    def refresh_all
      @posts = Post.limit(10)
    end

    # views/posts/refresh_all.js.rbjs
    for post in @posts
      jQuery(post.selector).html(render post)
    end

### Do complex stuff:

    # controllers/posts_controller.rb
    def increase_counter
      @increment = 4
    end
    
    # views/posts/increase_counter.js.rbjs
    allCounters = jQuery('.post.counter')
    allCounters.each do |index, element|
      element = jQuery(element)
      currentValue = element.html!.to_i!
      element.html(currentValue + @increment)
    end
    
    # And the rendered result. Note the behavior of local variables.
    jQuery(".post.counter").each(
      function(index, element) {
        jQuery(element).html(jQuery(element).html().to_i()+4)
      }
    )
    
    
    # Here is the same example, but with variables assigned to javascript instead of local ruby variables.
    # views/posts/increase_counter.js.rbjs
    self.allCounters = jQuery('.post.counter')
    self.allCounters.each do |index, element|
      self.element = jQuery(element)
      self.currentValue = element.html!.to_i!
      element.html(currentValue + @increment)
    end

    # And the rendered result:
    allCounters=(jQuery(".post.counter"));
    allCounters.each(function(index, element) {
      element=(jQuery(element));
      currentValue=(element.html().to_i());
      element.html(currentValue+4)
    })
    
More to come.