require 'rubygems'
require 'rbyate'

Yate.logger = Logger.new(STDOUT)

EM.run {
  yate = Yate::Connection.connect('127.0.0.1', 3000)

  yate.connected_callback { 
    [ "agent.register", "engine.status", "chan.attach", "call.execute"].each do |evt|
      yate.watch evt
    end
  }

  yate.event_callback { |event|
    puts "MY_EVENT: #{event.name} #{event.fields.name} ###############################"
  }
  
}
