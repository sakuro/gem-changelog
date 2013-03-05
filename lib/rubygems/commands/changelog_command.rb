# -*- encoding: UTF-8 -*-

require 'rubygems/command'

class Gem::Commands::ChangelogCommand < Gem::Command

  def initialize
    super 'changelog', 'Show the changelog of given gem'

    add_option '-f CHANGELOG_NAME', 'Specify name of the changelog file' do |v|
      options[:changelog_name] = v
    end
    add_option '-v VERSION', 'Specify version' do |v|
      options[:version_requirement] = v
    end
  end

  def execute
    args = options[:args]

    gem_name = args.first
    unless gem_name
      show_help
      terminate_interaction 1
    end
    version_requirement = options[:version_requirement]

    begin
      spec = Gem::Specification.find_by_name(gem_name, version_requirement)
    rescue Gem::LoadError => e
      say e.message
      terminate_interaction 1
    end

    changelog_file = options[:changelog_name] || find_changelog_file(spec)
    unless changelog_file
      if files(spec.gem_dir).empty?
        say('Changelog file could not be found.')
      else
        say('Changelog file could not be found. Try -f option with one of following file(s).')
        files.each do |file|
          say('- %s' % file)
        end
      end
      terminate_interaction 1
    end

    system(pager, File.join(spec.gem_dir, changelog_file))
  end

  def usage
    "#{program_name} GEM_NAME"
  end

  def arguments
    'GEM_NAME      name of the gem to show'
  end

  private

  CHANGELOG_RE = Regexp.union(/\ACHANGELOG\b/i, /\ACHANGES\b/i)

  def files(dir)
    Dir.entries(dir).select {|e| FileTest.file?(File.join(dir, e)) }
  end

  def find_changelog_file(spec)
    files(spec.gem_dir).sort.find {|file| CHANGELOG_RE === file }
  end

  def pager
    ENV['PAGER'] || 'more'
  end
end
