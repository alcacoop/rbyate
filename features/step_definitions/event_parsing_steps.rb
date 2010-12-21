require 'spec/expectations'

Before do
end

After do
end

Given /^the Yate::Event class method 'from_protocol_text'$/ do
  Yate::Event.respond_to?(:from_protocol_text).should be_true
end

When /^his parameter is equal to the Yate (.*)$/ do |event_text|
  @event = Yate::Event.from_protocol_text event_text
end

Then /^the result value is a Yate::Event instance$/ do
  (@event.class == Yate::Event).should be_true, "EVENT '#{@event}' is not a Yate::Event"
end

Then /^have attributes: name, etype, direction$/ do
  lambda {
    @attr = ""
    [:name, :etype, :direction].each do |attr|
      @attr = attr
      @event.send(attr) 
    end
  }.should_not raise_error(NoMethodError), "EVENT '#{@event}' MISSING ATTRIBUTE #{@attr}"
end

Given /^an event "([^\"]*)"$/ do |arg1|
  @event_text = arg1
end

When /^create an object with from_protocol_text$/ do
  @event = Yate::Event.from_protocol_text @event_text
end

Then /^the result value has a "([^\"]*)" parameter$/ do |arg1|
  attr_value = ""
  lambda {
    attr_value = @event.send(arg1) 
  }.should_not raise_error(NoMethodError), "EVENT '#{@event}' MISSING ATTRIBUTE #{@arg1}"  
  @attr_value = attr_value
end

Then /^his value it is "([^\"]*)"$/ do |arg1|
  @attr_value.should be_eql(arg1), "ACTUAL PARAMETERS #{@event.params.inspect}"
end



