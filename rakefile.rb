require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'rake/clean'
require 'flashsdk'
require 'asunit4'

##
# Set USE_FCSH to true in order to use FCSH for all compile tasks.
#
# You can also set this value by calling the :fcsh task 
# manually like:
#
#   rake fcsh run
#
# These values can also be sent from the command line like:
#
#   rake run FCSH_PKG_NAME=flex3
#
# ENV['USE_FCSH']         = true
# ENV['FCSH_PKG_NAME']    = 'flex4'
# ENV['FCSH_PKG_VERSION'] = '1.0.14.pre'
# ENV['FCSH_PORT']        = 12321

##############################
# Debug

# Compile the debug swf
mxmlc "bin/AS3Futures-debug.swf" do |t|
  t.input = "src/AS3Futures.as"
  t.debug = true
end

desc "Compile and run the debug swf"
flashplayer :run => "bin/AS3Futures-debug.swf"

##############################
# Test

library :asunit4

# Compile the test swf
mxmlc "bin/AS3Futures-test.swf" => :asunit4 do |t|
  t.input = "src/AS3FuturesRunner.as"
  t.source_path << 'tests'
  t.debug = true
end

desc "Compile and run the test swf"
flashplayer :test => "bin/AS3Futures-test.swf"

##############################
# SWC

compc "bin/AS3Futures.swc" do |t|
  t.input_class = "AS3Futures"
  t.source_path << 'src'
  t.include_sources << 'src/org'
end

desc "Compile the SWC file"
task :swc => 'bin/AS3Futures.swc'

##############################
# DOC

desc "Generate documentation at doc/"
asdoc 'doc' do |t|
  t.doc_sources << "src"
  t.exclude_sources << "src/AS3FuturesRunner.as"
end

##############################
# DEFAULT
task :default => :swc

