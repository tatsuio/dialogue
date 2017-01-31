module Converse
  class TemplateAlreadyRegisteredError < RuntimeError
    def initialize(template)
      super "A template with the name #{template.name} has already been registered"
    end
  end
end
