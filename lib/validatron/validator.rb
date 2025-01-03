require_relative "validators/base_validator"
require_relative "validators/string_validator"
require_relative "validators/number_validator"
require_relative "validators/boolean_validator"

module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    VALIDATORS = {
      string: Validators::StringValidator,
      number: Validators::NumberValidator,
      boolean: Validators::BooleanValidator
    }.freeze

    def self.validate(params, schema)
      errors = {}

      schema.rules.each do |key, options|
        value = params[key.to_s] || params[key.to_sym]
        message = options[:message]

        missing_options = REQUIRED_OPTIONS.select { |option| options[option].nil? }
        if missing_options.any?
          errors[key] = message || "must have a #{missing_options.join(", ")} defined"
          next
        end

        validator_class = VALIDATORS[options[:type].to_sym]
        validator = validator_class.new(key, value, options, errors)
        validator.validate
      end

      raise ValidationError.new(errors) unless errors.empty?
    end
  end
end
