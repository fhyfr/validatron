module Validatron
  class Schema
    attr_reader :rules

    def initialize
      @rules = {}
    end

    def required(name, **options)
      @rules[name] = { required: true, **options }
    end

    def optional(name, **options)
      @rules[name] = { required: false, **options }
    end
  end
end
