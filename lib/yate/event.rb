require 'ostruct'

module Yate
  class Event
        
    class << self
          
      def from_protocol_text(text)
        evt = parse_line text
        new(evt)
      end
          
      def parse_line(line)
        event = OpenStruct.new
        fields = OpenStruct.new
        params = OpenStruct.new

        line = line.split(":")
        rawevent = line[0]
        cols = line.slice(1..-1).map do |col|
          col.gsub("%z", ":").gsub('%%', '%')
        end

        case rawevent
        when "Error in": 
            raise cols[0]
        when "%%>message":
            fields.msgid,fields.time,fields.name,fields.retvalue,*fields.params = cols
            fields.processed = false
            event.name, event.etype, event.direction = ["message", "new", "incoming"]
            event.fields = fields
            return event
        when "%%<message":
            fields.msgid,fields.processed,fields.name,fields.retvalue,*fields.params = cols
            event.name, event.etype, event.direction = ["message", "answer", "incoming"]
            event.fields = fields
            return event
        when "%%<install":
            fields.priority,fields.name,fields.success = cols
            event.name, event.etype, event.direction = ["install", "answer", "incoming"]
            event.fields = fields
            return event
        when "%%<uninstall":
            fields.priority,fields.name,fields.success = cols
            event.name, event.etype, event.direction = ["uninstall", "answer", "incoming"]
            event.fields = fields
            return event
        when "%%<watch":
            fields.name,fields.success = cols
            event.name, event.etype, event.direction = ["watch", "answer", "incoming"]
            event.fields = fields
            return event
        when "%%<unwatch":
            fields.name,fields.success = cols
            event.name, event.etype, event.direction = ["unwatch", "answer", "incoming"]
            event.fields = fields
            return event
        when "%%<setlocal":
            fields.name,fields.value,fields.success = cols
            event.name, event.etype, event.direction = ["setlocal", "answer", "incoming"]
            event.fields = fields
            return event
        else
          raise "NOT IMPLEMENTED: unkown '#{event}' event"
        end
      end
          
    end

    def logger
      Yate.logger
    end
        
    def initialize(event)
      @event_data = event
    end
    
    def to_s
      ### FIXME: Not Implemented
      raise "NOT IMPLEMENTED"
    end
        
    def to_ack_s
      evt = @event_data
      fields = @event_data.fields
      
      return nil if (evt.name != "message" or evt.etype != "new") or
                    (fields.msgid and not fields.msgid.empty?)

      params = fields.params.map { |param| param.gsub(":", "%z") }

      "%%<#{['message',fields.msgid,fields.processed,fields.name,fields.retvalue,params].join(":")}\n" 
    end
        
  end
      
end
