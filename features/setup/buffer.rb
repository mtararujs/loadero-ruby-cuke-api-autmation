# Class for storing variables accross multiple test steps
class Buffer
    def initialize
      @buffer = {}
    end

    def get_values
      @buffer
    end

    def add_value(key, value)
      @buffer[key] = value
    end

    def get_value(key)
     @buffer[key]
    end

  def add_map(input_map)
    @buffer = @buffer.merge(input_map)
  end
end
