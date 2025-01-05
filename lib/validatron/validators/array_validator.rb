module Validatron
  module Validators
    class ArrayValidator < BaseValidator
      # Available validations for ArrayValidator:
      # - length: 5 => must have exactly 5 items
      # - min: 0 => must have at least 0 items
      # - max: 100 => must have at most 100 items
      # - unique: true => must have unique items, ex: [1, 2, 3] is valid, [1, 1, 2] is invalid
      # - items: { type: :string, min: 1, max: 100 } => must have items that match the schema
      def validate
        return unless value

        custom_message = options[:message]

        unless value.is_a?(Array)
          add_error(custom_message || "must be an array")
          return
        end

        if options[:length] && value.length != options[:length]
          add_error(custom_message || "must have exactly #{options[:length]} items")
        end

        if options[:min] && value.length < options[:min]
          add_error(custom_message || "must have at least #{options[:min]} items")
        end

        if options[:max] && value.length > options[:max]
          add_error(custom_message || "must have at most #{options[:max]} items")
        end

        add_error(custom_message || "must have unique items") if options[:unique] && value.uniq.length != value.length

        return unless options[:items]

        value.each_with_index do |item, index|
          item_key = :"#{key}[#{index}]"

          # Handle items with missing or invalid schema
          if options[:items].nil?
            errors[item_key] = "must have a schema for items"
            next
          end

          item_options = options[:items]

          # Check if :type is present and valid
          if item_options[:type].nil?
            errors[item_key] = "item must have a valid type"
            next
          end

          validator_class = Validator::VALIDATORS[item_options[:type].to_sym]

          if validator_class
            nested_validator = validator_class.new(item_key, item, item_options, errors)
            nested_validator.validate
          elsif item_options[:type] == :hash
            # Handle nested hash items
            nested_schema = Schema.new(item_options[:keys])
            Validator.validate(item, nested_schema)
          elsif item_options[:type] == :array
            # Handle nested array items (if array of arrays)
            nested_schema = Schema.new(item_options[:items])
            nested_validator = Validator::VALIDATORS[:array].new(item_key, item, nested_schema, errors)
            nested_validator.validate
          else
            errors[item_key] = "Unknown type: #{item_options[:type]}"
          end
        end
      end
    end
  end
end
