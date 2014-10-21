module Calabash
  module RspecTests
    module UIA
      class TestObject
        include Calabash::Cucumber::UIA
      end
    end
  end
end

describe Calabash::Cucumber::UIA do

  let(:test_obj) { Calabash::RspecTests::UIA::TestObject.new }

  describe 'uia_result' do
    describe "when 'status' key is 'success' returns" do
      it "value of the 'value' key when key exists" do
        value = {:key => :value }
        input = {'status' => 'success', 'value' => value, 'index' =>0}
        expect(test_obj.send(:uia_result, input)).to be == value
      end

      it "empty hash when 'value' key does not exist" do
        input = {'status' => 'success', 'index' =>0}
        expect(test_obj.send(:uia_result, input)).to be == nil
      end
    end

    describe "when 'status' key is not 'success' returns" do
      it 'the argument it was passed' do
        input = {'status' => 'error', 'value' => nil, 'index' =>0}
        expect(test_obj.send(:uia_result, input)).to be == input
      end
    end
  end

  describe 'uia_type_string' do
    describe 'does not raise an error' do
      it "when :status == 'success' and :value is a hash" do
        mocked_value = {}
        expect(test_obj).to receive(:uia_handle_command).and_return(mocked_value)
        expect { test_obj.uia_type_string 'foo' }.not_to raise_error
      end

      it "when :status == 'success' and :value is not a Hash" do
        # Output from typing in UIWebViews.
        mocked_value = ':nil'
        expect(test_obj).to receive(:uia_handle_command).and_return(mocked_value)
        expect { test_obj.uia_type_string 'foo' }.not_to raise_error
      end

      it "when :status != 'success' or 'error'" do
        mocked_value = {'status' => 'unknown', 'value' => 'error message', 'index' =>0}
        expect(test_obj).to receive(:uia_handle_command).and_return(mocked_value)
        expect { test_obj.uia_type_string 'foo' }.not_to raise_error
      end
    end

    describe "raises an error when :status == 'error'" do
      it 'and result has a :value key' do
        mocked_value = {'status' => 'error', 'value' => 'error message', 'index' =>0}
        expect(test_obj).to receive(:uia_handle_command).and_return(mocked_value)
        expect { test_obj.uia_type_string 'foo' }.to raise_error
      end

      it 'and result does not have a :value key' do
        mocked_value = {'status' => 'error', 'index' =>0}
        expect(test_obj).to receive(:uia_handle_command).and_return(mocked_value)
        expect { test_obj.uia_type_string 'foo' }.to raise_error
      end
    end
  end
end
