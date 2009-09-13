require 'rubygems'
require 'eventmachine'

module Yate
  
  class Connection < EM::Protocols::LineAndTextProtocol
    class << self
      def connect(host, port)
        EM.error_handler { |e|
          Yate.logger.error "Error raised during event loop: #{e.message}"
        }

        EM.connect(host, port, self)
      end
    end

    def logger
      Yate.logger
    end

    def connected_callback(&block)
      @connected_callback = EM.spawn { block.call }
    end

    def event_callback(&block)
      @event_callback = EM.spawn { |value| block.call(value) }
    end

    def error_callback(&block)
      EM.error_handler block
    end
        
    def initialize(*args)
      super
    end
        
    def connection_completed
      logger.info "Connection established"
      connect
      @connected_callback.notify
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
      logger.debug "SENDING %%>#{event}:#{params.join(':')}"
      send_data "%%>#{event}:#{params.join(':')}\n"
    end
        
    def receive_line(raw_event)
      logger.debug "RECEIVING #{raw_event.inspect}"
      event = Yate::Event.from_protocol_text raw_event
      logger.debug event.inspect

      @event_callback.notify event if @event_callback

      acknowledge event
    rescue => e
      logger.error e, *e.backtrace
    end
    
    def acknowledge(event)
      send_data event.to_ack_s
    end
    
  end
end
