module Yate
  class Event
        
    class << self
          
      def from_protocol_text(text)
        evt = parse_line text
        new(evt)
      end
          
      def parse_line(line)
        event = {}
        data = {}
        params = {}

        line = line.split(":")
        rawevent = line[0]
        cols = line.slice(1..-1).map do |col|
          col.gsub("%z", ":").gsub('%%', '%')
        end

        case rawevent
        when "Error in": 
            raise cols[0]
        when "%%>message":
            data[:msgid],data[:time],data[:name],data[:retvalue],*rawparams = cols
            data[:processed] = false
            event[:name], event[:etype], event[:direction] = ["message", "new", "incoming"]
            rawparams.each do |param|
              key, value = param.split("=")
              params[key.to_sym] = value
            end
            event[:data] = data ; event[:params] = params
            return event
        when "%%<message":
            data[:msgid],data[:processed],data[:name],data[:retvalue],*rawparams = cols
            event[:name], event[:etype], event[:direction] = ["message", "answer", "incoming"]
            rawparams.each do |param|
              key, value = param.split("=")
              params[key.to_sym] = value
            end
            event[:data] = data ; event[:params] = params
            return event
        when "%%<install":
            data[:priority],data[:name],data[:success] = cols
            event[:name], event[:etype], event[:direction] = ["install", "answer", "incoming"]
            event[:data] = data
            return event
        when "%%<uninstall":
            data[:priority],data[:name],data[:success] = cols
            event[:name], event[:etype], event[:direction] = ["uninstall", "answer", "incoming"]
            event[:data] = data
            return event
        when "%%<watch":
            data[:name],data[:success] = cols
            event[:name], event[:etype], event[:direction] = ["watch", "answer", "incoming"]
            event[:data] = data
            return event
        when "%%<unwatch":
            data[:name],data[:success] = cols
            event[:name], event[:etype], event[:direction] = ["unwatch", "answer", "incoming"]
            event[:data] = data
            return event
        when "%%<setlocal":
            data[:name],data[:value],data[:success] = cols
            event[:name], event[:etype], event[:direction] = ["setlocal", "answer", "incoming"]
            event[:data] = data
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
      self.inspect
    end

    def method_missing(method_name,*args)
      return @event_data[method_name] if @event_data[method_name]
      if @event_data[:data] and method_name.to_s =~ /^evt_(.*)$/ 
        return @event_data[:data][$1.to_sym] 
      end
      if @event_data[:params] and method_name.to_s =~ /^msg_(.*)$/ 
        return @event_data[:params][$1.to_sym] 
      end
      case method_name
      when :event
        return @event_data
      when :data
        return @event_data[:data]
      when :params
        return @event_data[:params]
      end
      raise NoMethodError
    end
        
    def to_ack_s
      evt = @event_data
      data = @event_data[:data]
      
      return nil if (evt[:name] != "message" or evt[:etype] != "new") or
                    (data[:msgid] and not data[:msgid].empty?)

      params = @event_data[:params].map { |k,v| "#{k}=#{v}" }
      fields_ary = ['message',data[:msgid],data[:processed],data[:name],data[:retvalue],params]
      fields_ary.map { |param| param.gsub(":", "%z") }

      "%%<#{fields_ary.join(":")}\n" 
    end
        
  end
      
end
