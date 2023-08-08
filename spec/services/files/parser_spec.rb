require 'spec_helper'

describe Parser do
  let(:file_path) { 'https://example.com/file.txt' }
  let(:parser) { described_class.new(file_path:) }
  let(:file_validator_response) { Result.new(true, nil, nil) }
  let(:file_double) { double('File', read: file_content, close: true) }
  let(:file_content) { 'image1.com image2.com' }

  before do
    allow_any_instance_of(FileValidator).to receive(:validate).and_return(file_validator_response)
  end

  describe '#parse' do
    context 'when file path is valid' do
      before do
        allow(URI).to receive(:open).and_return(file_double)
      end

      context 'when file is valid' do
        it 'returns array of URLs' do
          result = parser.parse

          expect(result.success?).to be(true)
          expect(result.error).to be_nil
          expect(result.object).to eq(['image1.com', 'image2.com'])
        end
      end

      context 'when file is valid' do
        let(:file_validator_response) { Result.new(false, 'Validation failed', nil) }

        it 'returns the validation response' do
          result = parser.parse

          expect(result.success?).to be(false)
          expect(result.error).to eq('Validation failed')
        end
      end
    end

    context 'when URI is invalid' do
      before do
        allow(URI).to receive(:open).and_raise(URI::InvalidURIError)
      end

      it 'returns a failure response' do
        result = parser.parse

        expect(result.success?).to be(false)
        expect(result.error).to eq('something went wrong while access the file.')
      end
    end
  end
end
