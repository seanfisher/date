# This file is automatically copied into RAILS_ROOT/initializers

require "smtp_tls"

config_file = "#{RAILS_ROOT}/config/smtp_gmail.yml"
raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)

config_options = YAML.load_file(config_file) 
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :domain         => 'gmail.com',
  :enable_starttls_auto => true
}.merge(config_options) # Configuration options override default options

  
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = :true
ActionMailer::Base.raise_delivery_errors = :false
ActionMailer::Base.default_charset = "utf-8"