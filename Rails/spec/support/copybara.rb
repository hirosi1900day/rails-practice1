Capybara.register_driver :remote_chrome do |app|
    url = 'http://chrome:4444/wd/hub'
    args = %w(no-sandbox disable-gpu mute-audio window-size=1280,800 lang=ja)
    args << 'headless' unless ENV['NO_HEADLESS']
    caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: {
            args: args
        }
    )
    Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: caps)
  end
  
  RSpec.configure do |config|
  
    config.before(:each, type: :system) do
      driven_by :rack_test, screen_size: [1920, 1080]
    end
  
    if ENV['CI']
      config.before(:each, type: :system) do
        driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
      end
    else
      config.before(:each, type: :system) do
        driven_by :remote_chrome
        Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
        Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
      end
    end
  end