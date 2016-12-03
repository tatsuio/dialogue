require "converse/dsl"

module Converse
  def self.build(&block)
    DSL.run block
  end
end
