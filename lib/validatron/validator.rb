require_relative "validators/base_validator"
require_relative "validators/string_validator"
require_relative "validators/number_validator"
require_relative "validators/array_validator"
require_relative "validators/hash_validator"
require_relative "validators/date_validator"
require_relative "validators/boolean_validator"

module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    VALIDATORS = {
      string: Validators::StringValidator,
      number: Validators::NumberValidator,
      array: Validators::ArrayValidator,
      hash: Validators::HashValidator,
      date: Validators::DateValidator,
      boolean: Validators::BooleanValidator
    }.freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_sym]

        # Assign default value if field is missing
        if value.nil? && options.key?(:default)
          value = options[:default]
          params[key] = value
        end

        message = options[:message]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        if missing_options.any?
          errors[key] = message || "must have a #{missing_options.join(", ")} defined"
          next
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
