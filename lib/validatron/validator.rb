require_relative "validators/base_validator"
require_relative "validators/string_validator"
require_relative "validators/number_validator"
require_relative "validators/boolean_validator"
require_relative "validators/array_validator"
require_relative "validators/date_validator"

module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    VALIDATORS = {
      string: Validators::StringValidator,
      number: Validators::NumberValidator,
      boolean: Validators::BooleanValidator,
      array: Validators::ArrayValidator,
      date: Validators::DateValidator
    }.freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_sym]
        message = options[:message]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        if missing_options.any?
          errors[key] = message || "must have a #{missing_options.join(", ")} defined"
          next
        end

        if options[:required] && value.nil?
          errors[key] = message || "#{key} is required"
          next
        end

        if value.nil? && options.key?(:default)
          value = options[:default]
          params[key] = value
        end

        validator_class = VALIDATORS[options[:type].to_sym]
        if validator_class
          validator = validator_class.new(key, value, options, errors)
          validator.validate
        else
          errors[key] = "Unknown type: #{options[:type]}"
        end
      end

      raise ValidationError.new(errors) unless errors.empty?
    end
  end
end
