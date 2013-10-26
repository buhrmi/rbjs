# Rbjs is a Ruby DSL that translates 1-to-1 into Javascript

It integrates with Rails 3.1 and 4, and Sinatra

## What?

With Rbjs you can transform this (create.js.erb)

    <% if @collection %>
      jQuery(<%= j render(@image) %>).appendTo('<%= dom_id @collection %>').hide().show('slide')    
    <% else %>
      jQuery(<%= j render(@image) %>).insertAfter('.dropzone').hide().show('slide')
    <% end %>

into this (create.js.rb)

    if @collection
      jQuery(render @image).appendTo(dom_id @collection).hide!.show('slide')    
    else
      jQuery(render @image).insertAfter('.dropzone').hide!.show('slide')
    end

## Why?

Why not?

## Installation

Add the line

    gem 'rbjs'
    
to your Gemfile and run

    bundle install
    
## Usage

Please refer to the [documentation](http://buhrmi.github.com/rbjs) for a quick example and usage guide.
