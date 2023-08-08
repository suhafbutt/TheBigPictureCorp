require 'spec_helper'
require_relative '../../lib/validators/file_validator'

describe FileValidator do
  let(:text_file) { double(File, content_type:) }
  let(:extension_type) { '.txt' }
  let(:content_type) { 'text/plain' }

  before do
    allow(File).to receive(:extname).and_return(extension_type)
  end

  describe '#validate' do
    context 'locally stored file' do
      let(:service) { described_class.new(file: text_file, file_path: '/tmp/plain.txt') }

      it 'returns successful result object' do
        expect(service.validate).to be_success
      end

      context 'when file is missing' do
        let(:text_file) { nil }

        it 'returns an unsuccessful result object with error message' do
          result = service.validate
          expect(result).not_to be_success
          expect(result.error).to include('File does not exist')
        end
      end

      context 'when extension is invalid' do
        let(:extension_type) { '.xlsx' }

        it 'returns an unsuccessful result object with error message' do
          result = service.validate
          expect(result).not_to be_success
          expect(result.error).to include('File is not of valid type')
        end
      end
    end

    context 'remote file' do
      let(:service) { described_class.new(file: text_file, file_path: 'https://thebigcorp.com/plain.txt') }

      it 'returns successful result object' do
        expect(service.validate).to be_success
      end

      context 'when file is missing' do
        let(:text_file) { nil }

        it 'returns an unsuccessful result object with error message' do
          result = service.validate
          expect(result).not_to be_success
          expect(result.error).to include('File does not exist')
        end
      end

      context 'when extension is invalid' do
        let(:extension_type) { '.xlsx' }

        it 'returns an unsuccessful result object with error message' do
          result = service.validate
          expect(result).not_to be_success
          expect(result.error).to include('File is not of valid type')
        end
      end

      context 'when content type is invalid' do
        let(:content_type) { 'image/png' }

        it 'returns an unsuccessful result with invalid content type error' do
          result = service.validate
          expect(result).not_to be_success
          expect(result.error).to include('File content type is not valid')
        end
      end
    end
  end
end
