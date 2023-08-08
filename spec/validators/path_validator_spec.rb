require 'spec_helper'
require_relative '../../lib/validators/path_validator'

describe PathValidator do
  describe '.directory?' do
    context 'when the path is a valid directory' do
      let(:valid_directory) { 'lib/validators' }

      it 'returns a successful result object ' do
        result = described_class.directory?(valid_directory)
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
        expect(result.object).to eq(valid_directory)
      end
    end

    context 'when the path is not a valid directory' do
      let(:invalid_directory_path) { '/home/directory/xyz' }

      it 'returns an unsuccessful result object with error message' do
        result = described_class.directory?(invalid_directory_path)
        expect(result.success?).to be(false)
        expect(result.error).to eq('Directory does not exist')
        expect(result.object).to eq(invalid_directory_path)
      end
    end
  end
end
