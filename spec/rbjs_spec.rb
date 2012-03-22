require 'rbjs'

describe Rbjs::Root, '#evaluate' do

	def dummy_context
		Struct.new(:assigns).new 'instance_var' => "Instance"
		#@instance_var = "Instance"
	end

  def build &block
  	js = Rbjs::Root.new dummy_context, &block
  	js.evaluate
  end

	it "should call simple functions" do
    js = build do
      alert "hi"
    end
    js.strip.should == 'alert("hi")'
  end


  it "should call nested functions" do
    js = build do
      alert(hey(123, :foo), ho('wow', level3(:yey)))
    end
    js.strip.should == 'alert(hey(123, "foo"), ho("wow", level3("yey")))'
  end
  
  it "should call simple functions on objects" do
    js = build do
      window.alert "hi"
    end
    js.strip.should == 'window.alert("hi")'
  end
  
  it "should distinguish between property access and method calls" do
    js = build do
      window.alert
      window.alert!
    end
    js.strip.should == "window.alert;\nwindow.alert()"
  end
  
  it 'should convert symbols into strings' do
    js = build do
      alert :hi
    end
    js.strip.should == 'alert("hi")'
  end
    
  it "should convert blocks to functions" do
    js = build do
      func do |an_argument, another_arg|
        an_argument.some_func!
        alert(another_arg)
        alert(another_arg.some_property)
      end
    end
    js.strip.should == "func(function(an_argument, another_arg) {\nan_argument.some_func();\nalert(another_arg);\nalert(another_arg.some_property)})"
  end

  it "should convert procs to functions" do
    js = build do
      some_proc = ->(an_argument, another_arg) do
        an_argument.some_func!
        alert(another_arg)
        alert(another_arg.some_property)
      end
      setTimeout some_proc, 1000
    end
    js.strip.should == "setTimeout(function(an_argument, another_arg) {\nan_argument.some_func();\nalert(another_arg);\nalert(another_arg.some_property)}, 1000)"
  end

  it "should convert hashes to javascript objects" do
    js = build do
      func(a_key => :a_value)
    end
    js.strip.should == 'func({a_key: "a_value"})'
  end

  it "should correctly nest property access" do
    js = build do
      foo.bar!.bla ble => some!.thing(with => :alot), :of_stuff => 1234
    end
    js.strip.should == 'foo.bar().bla({ble: some().thing({with: "alot"}),"of_stuff": 1234})'
  end

  it "should support array conversion" do
    js = build do
      self.my_array = [1,:asd, some(innermethod)];
    end
    js.strip.should == 'my_array=([1, "asd", some(innermethod)])'
  end

  it "should support array access" do 
    js = build do
      alert(something[:name])
    end
    js.strip.should == 'alert(something["name"])'
  end
  
  it "should support array assignment" do
    js = build do
      something[:name] = 123
    end
    js.strip.should == 'something["name"]= 123'
  end  
  
  it "should escape javascript" do
    js = build do
      alert("This is a quote: \", this is a backslash: \\")
    end
    js.strip.should == 'alert("This is a quote: \\", this is a backslash: \\\\")'
  end
  
  it "should can access outer local scope and the view context" do

    local_var = "Local"
    js = build do
      alert(@instance_var+local_var)
    end
    js.strip.should == 'alert("InstanceLocal")'
  end

  it "should convert regexp to javascript" do
    js = build do
      docs.map do |doc|
        w.match /^_/
        emit doc
      end
    end
    js.strip.should == "docs.map(function(doc) {\nw.match(/^_/);\nemit(doc)})"
  end

  it "should render multiple calls to locally assigned expressions" do
    js = build do
      selector = jQuery('#content').find('.note')
      selector.hide!
      selector.html 'some text'
    end
    js.strip.should == "jQuery(\"#content\").find(\".note\").hide();\njQuery(\"#content\").find(\".note\").html(\"some text\")"
  end

  it "should support multiple nested functions" do
    js = build do
      jQuery('.note').fadeIn do
        delay 1000 do
          jQuery('.note').hide!
        end
      end
    end
    js.strip.should == ''
  end

end