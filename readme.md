# RJS IS BACK

## And it's better than ever before.

Rbjs is a modern RJS extension for Rails 3 and up. It stands for **r**u**b**y**j**ava**s**cript. In contrast to prototype-rails, this library is designed to work with all javascript frameworks.

However, it is *not* a drop-in replacement for _.rjs_. It does things quite differently.

### Take a look at a simple example:
  
    # controllers/greeter_controller.rb
    def greet_me
      render :js do
        window.alert "Hello, #{current_user_name}"
      end
    end

    # views/greeter/index.html.erb
    link_to "Hi there!", "greeter#greet_me", :remote => true

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
      @posts = Post.all.limit(10)
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
    allCounters.each do |counter|
      currentValue = counter.html!.to_i
      counter.html(currentValue + @increment)
    end

More to come.