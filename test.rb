require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require_relative('opt')


$opts = parse(ARGV)

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
    abort if user.empty? or pass.empty?

    visit('/')
    fill_in('user_id', :with => user)
    fill_in('password', :with => pass)
    click_on('Login')

    within_frame 'content' do
        page.find('#column2') if opts.verbose
        click_on('CAP.CE')
    end
    
    print page.html if opts.verbose

  end
end

Test.new.test_google(opts.user, opts.pass)
