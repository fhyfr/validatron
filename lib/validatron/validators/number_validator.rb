module Validatron
  module Validators
    class NumberValidator < BaseValidator
      # Available validations for NumberValidator:
      # - type: :number => must be a number
      # - min: 0 => must be at least 0
      # - max: 100 => must be at most 100
      # - integer: true => must be an integer
      # - float: true => must be a float
      # - positive: true => must be positive
      # - negative: true => must be negative
      # - gt: 0 => must be greater than 0
      # - gte: 0 => must be greater than or equal to 0
      # - lt: 100 => must be less than 100
      # - lte: 100 => must be less than or equal to 100
      # - eq: 42 => must be equal to 42
      # - precision: 2 => must have 2 decimal places
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Numeric)
          add_error(custom_message || "must be a number")
          return
        end

        add_error(custom_message || "must be at least #{options[:min]}") if options[:min] && value < options[:min]

        add_error(custom_message || "must be at most #{options[:max]}") if options[:max] && value > options[:max]

        add_error(custom_message || "must be an integer") if options[:integer] && !value.is_a?(Integer)

        add_error(custom_message || "must be a float") if options[:float] && !value.is_a?(Float)

        add_error(custom_message || "must be positive") if options[:positive] && value <= 0

        add_error(custom_message || "must be negative") if options[:negative] && value >= 0

        add_error(custom_message || "must be greater than #{options[:gt]}") if options[:gt] && value <= options[:gt]

        if options[:gte] && value < options[:gte]
          add_error(custom_message || "must be greater than or equal to #{options[:gte]}")
        end

        add_error(custom_message || "must be less than #{options[:lt]}") if options[:lt] && value >= options[:lt]

        if options[:lte] && value > options[:lte]
          add_error(custom_message || "must be less than or equal to #{options[:lte]}")
        end

        add_error(custom_message || "must be equal to #{options[:eq]}") if options[:eq] && value != options[:eq]

        return unless options[:precision] && value.to_s.split(".").last.length != options[:precision]

        add_error(custom_message || "must have #{options[:precision]} decimal places")
      end
    end
  end
end
