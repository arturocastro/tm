require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false

Capybara.default_driver = :selenium
#Capybara.default_driver = :poltergeist
#Capybara.javascript_driver = :poltergeist
Capybara.app_host = 'http://bbsistema.tecmilenio.edu.mx/'

module MyCapybaraTest
  class Test
    include Capybara::DSL
    def test_google
	visit('/')
	fill_in('user_id', :with => 'xxx')
	fill_in('password', :with => 'xxx')
	click_on('Login')

	page.has_content?('CAP.CE00028.5.17NOV2015') do
	  puts("holy!")
	end
    end
  end
end

t = MyCapybaraTest::Test.new
t.test_google

