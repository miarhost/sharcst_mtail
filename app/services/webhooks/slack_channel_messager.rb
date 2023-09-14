require 'rest-client'
class Webhooks::SlackChannelMessager < ApplicationService
  def initialize(url, resource_id)
    @url = url
    @resource = UploadAttachment.find(resource_id)
  end

  def call

    message = "You have new report for bucket logging for #{attachment_date}.
               Please download it on #{attachment_link}"

    RestClient.post(@url, {"text"=> message}.to_json, {content_type: :json, accept: :json})

  end
  private
  def attachment_link
    @resource.blob.service_url.sub(/\?.*/, '')
  end

  def attachment_date
    @resource.created_at
  end
end
