require 'aruba/cucumber'
require 'methadone/cucumber'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  
  @base_dir = FileUtils.pwd

  FileUtils.rm_rf "tmp/aruba", :verbose => true
  FileUtils.mkdir_p "tmp/aruba", :verbose => true
end

After do
  ENV['RUBYLIB'] = @original_rubylib
  FileUtils.chdir @base_dir, :verbose => true
end
