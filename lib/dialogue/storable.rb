module Dialogue
  module Storable
    def data
      @data ||= {}
    end

    def fetch(key, default=nil, &block)
      data.fetch key, default, &block
    end

    def store!(hash)
      data.merge! hash
    end
  end
end
