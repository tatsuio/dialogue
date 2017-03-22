require "singleton"

module Dialogue
  class TemplateFactory
    include Singleton

    attr_reader :templates

    def initialize
      @templates = []
    end

    def find(name)
      templates.find { |template| template.name.to_s == name.to_s }
    end

    def register(template)
      raise TemplateAlreadyRegisteredError.new(template) if registered?(template.name)
      templates << template
    end

    def registered?(name)
      !find(name).nil?
    end
  end
end
