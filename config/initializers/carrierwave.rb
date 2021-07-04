CarrierWave.configure do |config|

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV["S3_ACCESS_KEY"],
    aws_secret_access_key: ENV["S3_SECRET_KEY"],
    region: ENV["S3_REGION"],
    path_style: true
  }
  config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
  config.remove_previously_stored_files_after_update = false

  if Rails.env.development?
    config.fog_public = false
    config.fog_directory  = ENV["S3_BUCKET_NAME"]
  elsif Rails.env.staging?
    config.fog_public = false #cloodfront利用なければ
    config.fog_directory  = ENV["S3_BUCKET_NAME"]
    # config.asset_host = 'https://d3a3jeglo6h485.cloudfront.net' #cloudfront用
  elsif Rails.env.production?
    config.fog_public = false
    config.fog_directory  = ENV["S3_BUCKET_NAME"]
    # config.asset_host = 'https://d2zsxcb1sxm997.cloudfront.net' #cloudfront用
  end

end
