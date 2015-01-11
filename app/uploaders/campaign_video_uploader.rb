class CampaignVideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video

  process encode_video: [:mp4]
end
