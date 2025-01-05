RSpec.describe Validatron::Validators::BooleanValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when value is not a boolean (not true or false)" do
      it "adds an error" do
        described_class.new(:is_even, "bar", { type: :boolean }, errors).validate
        expect(errors[:is_even]).to eq("must be a boolean")
      end
    end

    context "when required is true and value is nil" do
      it "adds an error" do
        described_class.new(:is_even, nil, { type: :boolean, required: true }, errors).validate
        expect(errors[:is_even]).to eq("is required")
      end
    end

    context "when value is not true" do
      it "adds an error" do
        described_class.new(:is_even, false, { type: :boolean, truthy: true }, errors).validate
        expect(errors[:is_even]).to eq("must be true")
      end
    end

    context "when value is not false" do
      it "adds an error" do
        described_class.new(:is_even, true, { type: :boolean, falsy: true }, errors).validate
        expect(errors[:is_even]).to eq("must be false")
      end
    end

    context "when a custom message is provided" do
      it "uses the custom message" do
        described_class.new(:is_even, "bar", { type: :boolean, message: "custom message" }, errors).validate
        expect(errors[:is_even]).to eq("custom message")
      end
    end
  end

  describe "#validate positive cases" do
    context "when value is true" do
      it "does not add an error" do
        described_class.new(:is_even, true, { type: :boolean }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is false" do
      it "does not add an error" do
        described_class.new(:is_even, false, { type: :boolean }, errors).validate
        expect(errors).to be_empty
      end
    end
  end
end
