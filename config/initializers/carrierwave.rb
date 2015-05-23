if Rails.env.test? || Rails.env.cucumber? || Rails.env.development?
	CarrierWave.configure do |config|
  	config.storage = :file
  	config.enable_processing = false
  end
else
  amazons3 = AppConfiguration.for('amazons3')
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: amazons3.key,
    aws_secret_access_key: amazons3.secret,
    region: amazons3.region
    }
    config.fog_directory = amazons3.bucket
    config.fog_public = false
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}
  end
end