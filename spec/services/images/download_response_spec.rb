require 'spec_helper'

describe DownloadResponse do
  describe '#overview' do
    let(:list_of_success_results) do
      [
        Result.new(true, nil, nil),
        Result.new(true, nil, nil),
        Result.new(true, nil, nil)
      ]
    end
    let(:list_of_failed_results) do
      [
        Result.new(false, 'some error 1', 'some url 1'),
        Result.new(false, 'some error 2', 'some url 2')
      ]
    end
    let(:failed_download_response) do
      [
        {
          image_url: 'some url 1',
          error_messages: 'some error 1'
        },
        {
          image_url: 'some url 2',
          error_messages: 'some error 2'
        }
      ]
    end

    let(:list_of_responses) { list_of_success_results + list_of_failed_results }

    let(:service) { described_class.new(list_of_responses) }

    it 'returns a formatted hash with success and failed results' do
      overview = service.overview

      expect(overview[:success_count]).to eq(3)
      expect(overview[:failed_count]).to eq(2)
      expect(overview[:failed_errors]).to eq(failed_download_response)
    end

    context 'when list_of_responses is empty' do
      let(:list_of_responses) { [] }

      it 'returns a a empty hash' do
        overview = service.overview

        expect(overview[:success_count]).to eq(0)
        expect(overview[:failed_count]).to eq(0)
        expect(overview[:failed_errors]).to eq([])
      end
    end
  end
end
