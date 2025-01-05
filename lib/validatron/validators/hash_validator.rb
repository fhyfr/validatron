module Validatron
  module Validators
    class HashValidator < BaseValidator
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Hash)
          add_error(custom_message || "must be a hash")
          return
        end

        return unless options[:keys]

        options[:keys].each do |hash_key, key_options|
          key_value = value[hash_key]
          scoped_key = :"#{key}.#{hash_key}"

          validator_class = Validator::VALIDATORS[key_options[:type].to_sym]
          if validator_class
            nested_validator = validator_class.new(scoped_key, key_value, key_options, errors)
            nested_validator.validate
          elsif key_options[:type] == :hash
            nested_schema = Schema.new(key_options[:keys])
            Validator.validate(key_value || {}, nested_schema)
          elsif key_options[:type] == :array
            nested_options = { type: :array, items: key_options[:items] }
            nested_validator = Validator::VALIDATORS[:array].new(scoped_key, key_value, nested_options, errors)
            nested_validator.validate
          else
            errors[scoped_key] = "Unknown type: #{key_options[:type]}"
          end
        end
      end
    end
  end
end
