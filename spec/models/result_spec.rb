require 'spec_helper'
require_relative '../../lib/models/result'

RSpec.describe Result do
  it 'responds to the success attribute' do
    result = Result.new(true, nil, 'Hello')
    expect(result.success?).to be_truthy
  end

  it 'responds to the error attribute' do
    error_message = 'error_message'
    result = Result.new(false, error_message, nil)
    expect(result.error).to eq(error_message)
  end

  it 'responds to the object attribute' do
    result = Result.new(true, nil, 'Hello')
    expect(result.object).to eq('Hello')
  end
end
