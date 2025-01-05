require_relative "validators/base_validator"
require_relative "validators/string_validator"
require_relative "validators/number_validator"
require_relative "validators/array_validator"
require_relative "validators/object_validator"
require_relative "validators/date_validator"
require_relative "validators/boolean_validator"

module Validatron
  class Validator
    REQUIRED_OPTIONS = [:type].freeze

    VALIDATORS = {
      string: Validators::StringValidator,
      number: Validators::NumberValidator,
      array: Validators::ArrayValidator,
      object: Validators::ObjectValidator,
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

          # Handle nested objects
          if options[:keys].is_a?(Hash)
            nested_schema = Validatron::Schema.new(options[:keys])
            nested_params = value.is_a?(Hash) ? value : {}
            nested_errors = {}
            validate(nested_params, nested_schema)
            nested_errors.each do |nested_key, nested_message|
              errors["#{key}.#{nested_key}".to_sym] = nested_message
            end
          end

          # Handle arrays of objects
          if options[:items].is_a?(Hash) && options[:items][:type] == :object
            value.each_with_index do |item, index|
              nested_schema = Validatron::Schema.new(options[:items][:keys])
              nested_params = item.is_a?(Hash) ? item : {}
              nested_errors = {}
              validate(nested_params, nested_schema)
              nested_errors.each do |nested_key, nested_message|
                errors["#{key}[#{index}].#{nested_key}".to_sym] = nested_message
              end
            end
          end
        else
          errors[key] = "Unknown type: #{options[:type]}"
        end
      end

      raise ValidationError.new(errors) unless errors.empty?
    end
  end
end
