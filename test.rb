require 'rubygems'
require 'optparse'
require 'ostruct'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

def self.parse(args)
  options = OpenStruct.new
  options.browser = "firefox"
  options.user = ""
  options.pass = ""
  options.verbose = false

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.separator ""
    opts.separator "Specific options:"

    opts.on("-uUSER", "--user USER", "User") do |u|
      options.user = u
    end

    opts.on("-pPASS", "--pass PASS", "Password") do |p|
      options.pass = p
    end

    opts.on("-bBROWSER", "--browser BROWSER", "User [firefox|chrome|phantomjs]") do |b|
      options.browser = b
    end

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options.verbose = v
    end

    opts.separator ""
    opts.separator "Common options:"

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end

  opt_parser.parse!(args)
  options
end

opts = parse(ARGV)

Capybara.run_server = false

if opts.browser == "chrome"
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end

if opts.browser == "phantomjs"
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
else 
  Capybara.default_driver = :selenium
end

Capybara.app_host = 'http://bbsistema.tecmilenio.edu.mx/'

class Test
  include Capybara::DSL
  def test_google(user, pass)
    if user.empty? or pass.empty? then abort end

    visit('/')
    fill_in('user_id', :with => user)
    fill_in('password', :with => pass)
    click_on('Login')
    
    if page.has_content?('CAP.CE00028.5.17NOV2015')
      puts("holy!")
    end
  end
end

Test.new.test_google(opts.user, opts.pass)
