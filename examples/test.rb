require 'rubygems'
require 'rbyate'

Yate.logger = Logger.new(STDOUT)

EM.run {
  connected_callback = lambda { |yate|
    [ "agent.register", "engine.status", "chan.attach", "call.execute"].each do |evt|
      yate.watch evt
    end
  }

  event_callback = lambda { |yate,event|
    puts event.inspect
  }
  
  yate = Yate::Connection.connect("127.0.0.1","3000", connected_callback, event_callback)
}
