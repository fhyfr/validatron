# Validatron

**Validatron** is a lightweight Ruby gem designed to handle request parameter validation. It provides a simple and flexible API for defining validation schemas, ensuring that incoming data is in the correct format before processing.

This gem can be used for validating API request parameters (e.g., body, query parameters) in Ruby on Rails applications.

## Table of Contents

- [Why Validatron?](#why-validatron)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Schema Definitions](#schema-definitions)
  - [Validation Types](#validation-types)
  - [Custom Error Messages](#custom-error-messages)
  - [Optional Fields](#optional-fields)
  - [Error Handling](#error-handling)
- [Features](#features)
- [Development](#development)
  - [Running Tests](#running-tests)
  - [Changelog Generation](#changelog-generation)
- [License](#license)

## Why Validatron?

### Security Concerns

When handling API requests, especially when accepting user input, it's crucial to validate incoming data to prevent various types of security vulnerabilities, such as SQL injection, cross-site scripting (XSS), and data integrity issues. By using **Validatron**, you ensure that only well-formed, validated data enters your system, reducing the risk of these types of attacks.

- **Prevent Malicious Input**: By defining strict validation rules for each parameter, you ensure that invalid or harmful data (such as scripts or SQL injection payloads) is rejected before it can be processed.
- **Data Integrity**: Validating input types (e.g., ensuring a field that should be a string is actually a string) ensures that your application processes only valid data, which helps maintain data integrity.
- **Early Detection of Errors**: Catching validation errors before they reach the database or application logic helps reduce potential security breaches and makes your system more robust.

### Other Reasons to Use Validatron

- **Simple and Declarative API**: **Validatron** provides a clear, easy-to-use syntax for defining validation schemas, making it simple to understand and maintain.
- **Flexible Schema Definitions**: You can define both required and optional parameters, apply multiple types of validation (e.g., type checks, format checks, comparisons), and customize error messages.
- **Reusable and Maintainable**: By defining validation rules separately from your models, you keep your application logic cleaner and more maintainable. This approach also makes it easier to update validation rules across your application without having to touch every model.
- **Centralized Validation Logic**: Centralizing validation logic helps ensure consistency across your application and reduces the chances of inconsistent validation rules in different parts of your codebase.
- **Granular Control Over Validation**: **Validatron** gives you fine-grained control over how data is validated, including custom rules, error messages, and complex validation chains, which helps ensure that your application works as expected in a wide range of scenarios.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'validatron'
```

Then run:

```bash
bundle install
```

## Usage

### Basic Usage

Once installed, you can use **Validatron** to define validation schemas and validate your request parameters.

Example:

```ruby
params = { name: "John", email: "john@example.com", age: 25 }

schema = Validatron::Schema.new
schema.required(:name, type: :string)
schema.required(:email, format: /@/)
schema.optional(:age, gt: 0)

result = Validatron::Validator.validate(params, schema)

if result.success?
  # Continue processing valid parameters
else
  # Handle validation errors
  puts result.errors
end
```

### Schema Definitions

You can define required and optional parameters in your validation schema.

```ruby
schema = Validatron::Schema.new
schema.required(:name, type: :string)
schema.optional(:age, gt: 0)
```

### Validation Types

The `type` option allows you to specify the expected type of the parameter. Supported types include:

- `:string`
- `:integer`
- `:boolean`
- `:float`
- `:array`
- `:hash`

Example:

```ruby
schema.required(:name, type: :string)
schema.required(:age, type: :integer)
```

### Custom Error Messages

You can customize error messages by specifying a `message` option when defining a schema.

```ruby
schema.required(:name, type: :string, message: "Name is required and must be a string")
```

### Optional Fields

To define optional fields, use the `optional` method. You can also apply additional validations on optional fields.

```ruby
schema.optional(:age, gt: 0)
```

This ensures that the `age` field, if present, must be greater than 0 (zero).

### Error Handling

If validation fails, the result will contain a list of errors. You can check for validation success and handle errors accordingly.

```ruby
result = Validatron::Validator.validate(params, schema)

if result.success?
  # Proceed with valid parameters
else
  # Display validation errors
  result.errors.each { |error| puts error }
end
```

## Features

- **Required and Optional Fields**: Define both required and optional fields in the schema.
- **Multiple Validation Types**: Validate different types of data (e.g., string, integer, boolean, etc.).
- **Custom Error Messages**: Customize error messages for each field.
- **Granular Validation**: Fine-tune your validation with various options like `gt`, `lt`, `format`, and more.
- **Error Reporting**: Easy access to validation errors for handling in your application.

## Development

### Running Tests

To run the tests for **Validatron**, use RSPec:

1. Install the required dependencies:

```bash
bundle install
```

2. Run the tests:

```bash
rspec
```

### Changelog Generation

To geanerate the changelog automatically, you can use the `auto-changelog` tool (requires Node.js and npm):

1. Install `auto-changelog`:

```bash
npm install auto-changelog --save-dev
```

2. Add the changelog generation script to your `package.json`:

```json
"scripts": {
  "changelog": "auto-changelog"
}
```

3. Run the changelog generation:

```bash
npm run changelog
```

This will automatically update your `CHANGELOG.md` with the latest changes.

## Licence

This gem is available under the MIT Licence. See the [LICENSE](LICENSE.txt) file for more information.
