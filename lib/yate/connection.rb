require 'rubygems'
require 'eventmachine'

module Yate
      
  class Connection < EM::Protocols::LineAndTextProtocol
        
    class << self
      def connect(host, port)
        EM.connect(host, port, self)
      end
    end

    def logger
      Yate.logger
    end
        
    def initialize(*args)
      super
    end
        
    def post_init
      logger.info "Connection established"
      connect
      [ "agent.register", "engine.status", "chan.attach", "call.execute"].each do |evt|
          watch evt
      end
    rescue
      logger.error "RAISED EXCEPTION: #{$!}"
    end

    def unbind
      logger.info "Disconnected"
    end

    def connect(role = "global")
      send_event "connect", [ role ]
    end

    def install(message_name, options = {})
      send_event "install", [ options[:priority],
                             message_name,  
                             options[:filter_name], options[:filter_value] ]
    end

    def uninstall(message_name)
      raise "Not Implemented"
    end

    def watch(message_name)
      send_event "watch", [ message_name ]
    end

    def unwatch(message_name)
      raise "Not Implemented"
    end

    def set_local(name,value)
      raise "Not Implemented"
    end

    def send_event(event, params)
      # FIXME: params need escaping... it's better to
      #        assign to Message this task?
      logger.debug "SENDING %%>#{event}:#{params.join(':')}\n"
      send_data "%%>#{event}:#{params.join(':')}\n"
    end
        
    def receive_line(raw_message)
      logger.debug "Received #{raw_message.inspect}"
      message = Yate::Message.from_protocol_text raw_message
      logger.debug message.inspect

      acknowledge message
    rescue => e
      logger.fatal e, *e.backtrace
    end
    
    def acknowledge(message)
      send_event message.to_ack_s
    end
    
  end
end
