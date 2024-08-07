
require 'rspec/json_expectations'
require 'webmock/rspec'
require 'sidekiq/testing/inline'
require 'sidekiq-status/testing/inline'
WebMock.disable_net_connect!(allow_localhost: true)
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each) do
    stub_request(:post, ENV['ADMIN_SLACK_URL']).
    with(
      body: {"text": "You have new report for bucket logging for #{Time.now.utc}.
               Please download it on "}.to_json,
      headers: {
        'Accept'=>'application/json',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Length'=>'117',
        'Content-Type'=>'application/json',
        'Host'=>'hooks.slack.com',
        'User-Agent'=>'rest-client/2.1.0 (linux-gnu x86_64) ruby/2.7.1p83'
      }).
      to_return(status: 200, body: 'ok', headers: {})


    stub_request(:post, ENV['TEAMS_SLACK_URL']).
    with(
      body: {"Today's links": "https://example.com?download=, https://example1.com?download=, https://example2.com?download="}.to_json,
      headers: {
      'Accept'=>'application/json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Length'=>'113',
      'Content-Type'=>'application/json',
      'Host'=>'hooks.slack.com',
      'User-Agent'=>'Faraday v2.9.0'
      }).
    to_return(status: 200, body: "Sent to channel", headers: {})

    stub_request(:post, "https://api.twilio.com/#{DateTime.now.strftime("%y-%m-%d")}/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/#{ENV['TWILIO_SMS_SERVICE']}.json").
    with(:headers => {'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.1'}).
      to_return(:status => 200, :body => "[{'body': 'Sent from your Twilio trial account - New Event', 'status': 'queued'}]", :headers => {})

    stub_request(:post, "https://api.twilio.com/#{DateTime.now.strftime("%y-%m-%d")}/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}.Messages.json").
    with(
      body: {"Body"=>"Test Alert", "From"=>"whatsapp:#{ENV['TWILIO_SMS_SERVICE']}", "To"=>"whatsapp:#{ENV['TWILIO_TEST_USER_NUMBER']}"},
      headers: {'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Basic #{ENV['TW_MESSENGER_TOKEN']}",
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.1'}).
      to_return(status:200, body: "Successfully sent", headers: {})

    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json").
    with(
      body: {"Body"=>"New Event", "From"=>"#{ENV['TWILIO_SMS_SERVICE']}", "To"=>"#{ENV['TWILIO_TEST_USER_NUMBER']}"},
      headers: {
      'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Basic #{ENV['TW_MESSENGER_TOKEN']}",
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.1'
      }).
      to_return(status: 200, body: {'status': 'queued', 'body': 'Sent from your Twilio trial account - New Event'}.to_json, :headers => {})
    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json").
    with(
      body: {"Body"=>"New Event", "From"=>"#{ENV['TWILIO_SMS_SERVICE']}", "To"=>"+222222222"},
      headers: {
      'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Basic #{ENV['TW_MESSENGER_TOKEN']}",
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.1'
      }).
      to_return(:status => 200, :body => {'status': 'queued', 'body': 'Sent from your Twilio trial account - New Event'}.to_json, :headers => {})
    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json").
    with(
      body: {"Body"=>"New Event", "From"=>"#{ENV['TWILIO_SMS_SERVICE']}", "To"=>"+333333333"},
      headers: {
      'Accept'=>'application/json',
      'Accept-Charset'=>'utf-8',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Basic #{ENV['TW_MESSENGER_TOKEN']}",
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.1'
      }).
      to_return(:status => 200, :body => {'status': 'queued', 'body': 'Sent from your Twilio trial account - New Event'}.to_json, :headers => {})
    end
  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.
  #   # This allows you to limit a spec run to individual examples or groups
  #   # you care about by tagging them with `:focus` metadata. When nothing
  #   # is tagged with `:focus`, all examples get run. RSpec also provides
  #   # aliases for `it`, `describe`, and `context` that include `:focus`
  #   # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  #   config.filter_run_when_matching :focus
  #
  #   # Allows RSpec to persist some state between runs in order to support
  #   # the `--only-failures` and `--next-failure` CLI options. We recommend
  #   # you configure your source control system to ignore this file.
  #   config.example_status_persistence_file_path = "spec/examples.txt"
  #
  #   # Limits the available syntax to the non-monkey patched syntax that is
  #   # recommended. For more details, see:
  #   #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  #   config.disable_monkey_patching!
  #
  #   # Many RSpec users commonly either run the entire suite or an individual
  #   # file, and it's useful to allow more verbose output when running an
  #   # individual spec file.
  #   if config.files_to_run.one?
  #     # Use the documentation formatter for detailed output,
  #     # unless a formatter has already been configured
  #     # (e.g. via a command-line flag).
  #     config.default_formatter = "doc"
  #   end
  #
  #   # Print the 10 slowest examples and example groups at the
  #   # end of the spec run, to help surface which specs are running
  #   # particularly slow.
  #   config.profile_examples = 10
  #
  #   # Run specs in random order to surface order dependencies. If you find an
  #   # order dependency and want to debug it, you can fix the order by providing
  #   # the seed, which is printed after each run.
  #   #     --seed 1234
  #   config.order = :random
  #
  #   # Seed global randomization in this process using the `--seed` CLI option.
  #   # Setting this allows you to use `--seed` to deterministically reproduce
  #   # test failures related to randomization by passing the same `--seed` value
  #   # as the one that triggered the failure.
  #   Kernel.srand config.seed
end
