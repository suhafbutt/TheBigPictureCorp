class DownloadResponse
  attr_accessor :list_of_responses, :result_overview

  def initialize(list_of_responses)
    @list_of_responses = list_of_responses
    @result_overview = {}
    result_overview[:success_count] = 0
    result_overview[:failed_count] = 0
    result_overview[:failed_errors] = []
  end

  def overview
    list_of_responses.each do |response|
      next result_overview[:success_count] += 1 if response.success?

      result_overview[:failed_count] += 1
      result_overview[:failed_errors] << response
    end
    result_overview
  end

  private

  def process_failed_download(response)
    {
      image_url: response.object,
      error_messages: response.error
    }
  end
end
