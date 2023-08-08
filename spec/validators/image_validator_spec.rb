require 'spec_helper'

describe ImageValidator do
  let(:image) { double('Image', content_type:) }
  let(:service) { described_class.new(image:) }
  let(:content_type) { 'image/jpeg' }
  let(:extension_type) { '.png' }

  before do
    allow(File).to receive(:extname).and_return(extension_type)
  end

  describe '#validate' do
    context 'when valid image' do
      it 'returns a successful result' do
        result = service.validate
        expect(result.success?).to be(true)
        expect(result.error).to be_nil
      end
    end

    context 'when image is missing' do
      let(:image) { nil }

      it 'returns an unsuccessful result with error message' do
        result = service.validate
        expect(result.success?).to be(false)
        expect(result.error).to eq('Image content type is not valid')
      end
    end

    context 'when image content type is invalid' do
      let(:content_type) { 'text/plain' }

      it 'returns an unsuccessful result with error message' do
        result = service.validate
        expect(result.success?).to be(false)
        expect(result.error).to eq('Image content type is not valid')
      end
    end

    context 'when image extension is invalid' do
      let(:extension_type) { '.xlsx' }

      it 'returns an unsuccessful result with error message' do
        result = service.validate
        expect(result.success?).to be(false)
        expect(result.error).to eq('Image is not of valid type')
      end
    end
  end
end
