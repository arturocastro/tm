require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require_relative('opt')


$options = parse(ARGV)

Capybara.run_server = false

if $options.browser == "chrome"
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end

if $options.browser == "phantomjs"
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
        page.find('#column2') if $options.verbose
        click_on('CAP.CE')
    end
    
    print page.html if $options.verbose

  end
end

Test.new.test_google($options.user, $options.pass)
