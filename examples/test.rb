require 'rubygems'
require 'rbyate'

Yate.logger = Logger.new(STDOUT)

EM.run {
  yate = Yate::Connection.connect("127.0.0.1","3000")

  [ "agent.register", "engine.status", "chan.attach", "call.execute"].each do |evt|
    yate.watch evt
  end

}
