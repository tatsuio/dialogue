module Converse
  class DSL
    def on(intent, &block)
    end

    def self.run(block)
      new.instance_eval(&block)
    end
  end
end
