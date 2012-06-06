require 'rubygems'
require 'pathname'
dir = Pathname.new(__FILE__).parent
$LOAD_PATH.unshift(dir, dir + 'lib', dir + '../lib')

require 'mocha'
require 'puppet'
gem 'rspec', '>= 2.0.0'
require 'rspec/autorun'
