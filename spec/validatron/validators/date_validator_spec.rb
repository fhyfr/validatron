RSpec.describe Validatron::Validators::DateValidator do
  let(:errors) { {} }

  it "validates a date" do
    validator = described_class.new(:start_date, Date.today, { type: :date }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-date values" do
    validator = described_class.new(:start_date, "not a date", { type: :date }, errors)
    validator.validate
    expect(errors[:start_date]).to eq("must be a valid date")
  end

  it "adds an error for dates before min" do
    validator = described_class.new(:start_date, Date.new(2020, 1, 1), { type: :date, min: Date.new(2021, 1, 1) },
                                    errors)
    validator.validate
    expect(errors[:start_date]).to eq("must be on or after 2021-01-01")
  end

  it "adds an error for dates after max" do
    validator = described_class.new(:start_date, Date.new(2022, 1, 1), { type: :date, max: Date.new(2021, 12, 31) },
                                    errors)
    validator.validate
    expect(errors[:start_date]).to eq("must be on or before 2021-12-31")
  end

  it "validates ISO 8601 format" do
    validator = described_class.new(:start_date, "2023-10-10T00:00:00Z", { type: :date, iso: true }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-ISO 8601 format" do
    validator = described_class.new(:start_date, "10/10/2023", { type: :date, iso: true }, errors)
    validator.validate
    expect(errors[:start_date]).to eq("must be in ISO 8601 format")
  end

  it "validates a timestamp" do
    validator = described_class.new(:start_date, Time.now, { type: :date, timestamp: true }, errors)
    validator.validate
    expect(errors).to be_empty
  end
end
