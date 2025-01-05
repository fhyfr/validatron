module Validatron
  class RuleBuilder
    attr_reader :rules

    def initialize(type)
      @rules = { type: type }
    end

    def min(value)
      @rules[:min] = value
      self
    end

    def max(value)
      @rules[:max] = value
      self
    end

    def length(value)
      @rules[:length] = value
      self
    end

    def default(value)
      @rules[:default] = value
      self
    end

    def required
      @rules[:required] = true
      self
    end

    def optional
      @rules[:required] = false
      self
    end

    def message(value)
      @rules[:message] = value
      self
    end

    def pattern(value)
      @rules[:pattern] = value
      self
    end

    def email
      @rules[:email] = true
      self
    end

    def uri
      @rules[:uri] = true
      self
    end

    def uuid
      @rules[:uuid] = true
      self
    end

    def gt(value)
      @rules[:gt] = value
      self
    end

    def lt(value)
      @rules[:lt] = value
      self
    end

    def gte(value)
      @rules[:gte] = value
      self
    end

    def lte(value)
      @rules[:lte] = value
      self
    end

    def eq(value)
      @rules[:eq] = value
      self
    end

    def iso
      @rules[:iso] = true
      self
    end

    def unique
      @rules[:unique] = true
      self
    end

    def items(value)
      @rules[:items] = value
      self
    end

    def keys(value)
      @rules[:keys] = value
      self
    end

    def build
      @rules
    end
  end
end
