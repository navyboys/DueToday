Elasticsearch::Model.client =
  if Rails.env.staging? || Rails.env.production?
    Elasticsearch::Client.new host: ENV['SEARCHBOX_URL']
  elsif Rails.env.development?
    Elasticsearch::Client.new log: true
  else
    Elasticsearch::Client.new
  end
