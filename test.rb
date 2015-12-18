require 'rubygems'
require 'optparse'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [-chv] -u<user> -p<pass>"

  opts.on("-v", "Verbose") do |v|
    options[:verbose] = v
  end

  opts.on("-c", "Use Chrome") do |c|
    options[:chrome] = c
  end

  opts.on("-h", "Use PhantomJS (headless)") do |h|
    options[:headless] = h
  end

Capybara.run_server = false

if options[:chrome]
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end

if options[:headless] 
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
else 
  Capybara.default_driver = :selenium
end

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

