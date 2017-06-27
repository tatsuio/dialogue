module Dialogue
  module Storable
    def data
      @data ||= {}
    end

    def fetch(key, default=nil, &block)
      data.fetch key, default, &block
    end

    def has_data?(*keys)
      present = keys.all? { |key| data.has_key?(key) }
      if present
        present = keys.all? do |key|
          !data[key].nil? &&
            (!data[key].respond_to?(:empty?) || !data[key].empty?)
        end
      end
      present
    end

    def store!(hash)
      data.merge! hash
    end
  end
end
