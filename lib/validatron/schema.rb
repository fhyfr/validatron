module Validatron
  class Schema
    attr_reader :rules

    def initialize(rules = {})
      @rules = rules.transform_values do |rule|
        rule.is_a?(RuleBuilder) ? rule.build : rule
      end
    end

    def self.string
      RuleBuilder.new(:string)
    end

    def self.number
      RuleBuilder.new(:number)
    end

    def self.boolean
      RuleBuilder.new(:boolean)
    end

    def self.array
      RuleBuilder.new(:array)
    end

    def self.date
      RuleBuilder.new(:date)
    end

    def self.hash
      RuleBuilder.new(:hash)
    end
  end
end
