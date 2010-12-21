# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'rbyate'

task :default => 'spec:run'

PROJ.name = 'rbyate'
PROJ.authors = 'Luca Greco (Alca Società Cooperativa)'
PROJ.email = 'luca.greco@alcacoop.it'
PROJ.url = 'http://rbyate.rubyforge.org'
PROJ.version = Yate::VERSION
PROJ.rubyforge.name = 'rbyate'

PROJ.dependencies = [ 'eventmachine' ]
PROJ.exclude = ['.git', 'pkg', '.*~']

PROJ.spec.opts << '--color'

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
  t.rcov = true
end

# EOF
