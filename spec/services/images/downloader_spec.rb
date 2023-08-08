require 'spec_helper'
require 'down'

describe Downloader do
  describe '#call' do
    let(:image_urls) { ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'] }
    let(:destination_path) { '/path/to/destination/' }
    let(:service) { described_class.new(image_urls:, destination_path:) }
    let(:path_validator_response) { Result.new(true, nil, nil) }
    let(:image_validator_response) { Result.new(false, nil, nil) }

    before do
      allow(PathValidator).to receive(:directory?).and_return(path_validator_response)
      allow_any_instance_of(ImageValidator).to receive(:validate).and_return(image_validator_response)
      allow(FileUtils).to receive(:mv).and_return(true)
      allow(Down).to receive(:download).and_return(double(path: '/path/to/temp_image.jpg',
                                                          original_filename: 'temp_image.jpg'))
    end

    context 'when all validations pass' do
      it 'downloads and validates images' do
        result = service.call
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
        expect(result.object).to be_a(Array)
        expect(result.object.size).to eq(2)
      end
    end

    context 'when download thorws an exception' do
      before do
        allow(Down).to receive(:download).and_raise(StandardError)
      end

      it 'handles download and validation failure' do
        result = service.call
        error_messages = result.object.map { |e| e.error }
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
        expect(error_messages).to include('Something went wrong while downloading the image.')
      end
    end

    context 'when image validation fails' do
      let(:image_validator_response) { Result.new(false, 'some error', nil) }

      it 'handles download and validation failure' do
        result = service.call
        error_messages = result.object.map { |e| e.error }
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
        expect(error_messages).to include('some error')
      end
    end

    context 'when image validation fails' do
      let(:path_validator_response) { Result.new(false, 'some directory error', nil) }

      it 'handles directory validation failure' do
        result = service.call
        error_messages = result.object.map { |e| e.error }
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
        expect(error_messages).to include('some directory error')
      end
    end
  end
end
