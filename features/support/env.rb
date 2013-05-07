require 'aruba/cucumber'
require 'methadone/cucumber'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s

  @original_cwd = ENV['CWD']
  ENV['CWD'] = "/tmp/tart"
  FileUtils.rm_rf "/tmp/tart"
  FileUtils.mkdir "/tmp/tart"
  
  @original_pwd = ENV['PWD']
  FileUtils.cd "/tmp/tart"

end

After do
  FileUtils.cd @original_pwd
  ENV['RUBYLIB'] = @original_rubylib
  ENV['CWD'] = @original_cwd
end
