# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/rspec'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'rake'
require 'database_cleaner'
require 'active_storage/engine'
require 'factory_bot'
FactoryBot.find_definitions

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:suite) do
    # Connect to Redis
    redis = Redis.new

    # Clear all data in Redis
    redis.flushall
    # DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # Load seed data
    Rails.application.load_seed
  end


  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
  end

  config.after(:all) do
  end

  # config.before(:example) do
  #   domain_resolver_spy = instance_spy(
  #     DomainResolver,
  #     domain: 'example.com'
  #   )
  #   url = 'https://storage.googleapis.com/image/test.png'
  #   image_post_attrs = OpenStruct.new(
  #     url: 'https://storage.googleapis.com/my-bucket',
  #     fields: OpenStruct.new(
  #       'x-goog-meta-token': 'jwt-token',
  #       'x-goog-meta-redirect_url': 'redirect-url',
  #       'key': 'upload path',
  #       'x-goog-date': '20200911T150154Z',
  #       'x-goog-credential': 'creds',
  #       'x-goog-algorithm': 'GOOG4-RSA-SHA256',
  #       'x-goog-signature': 'signature',
  #       'policy': 'decoded policy string'
  #     )
  #   )
  #   allow(DomainResolver).to receive(:new).and_return(domain_resolver_spy)
  #   allow(domain_resolver_spy).to receive(:ns).and_return('ns.godaddy.com')
  #   allow(domain_resolver_spy).to receive(:cname).and_return('viceroy.popup.local')
  #   allow(domain_resolver_spy).to receive(:ns).and_return('ns.godaddy.com')
  #   allow_any_instance_of(ProductMedia).to receive(:signed_url).and_return(url)
  #   allow_any_instance_of(ProductMedia).to receive(:url_for_post).and_return(image_post_attrs)
  # end

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
end

