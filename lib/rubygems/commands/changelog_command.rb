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
    add_option '-n', '--lines=LINES', 'Show the first LINES lines of the changelog' do |v|
      raise OptionParser::InvalidArgument, v unless v =~ OptionParser::DecimalInteger
      options[:lines] = v.to_i
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
        files(spec.gem_dir).each do |file|
          say('- %s' % file)
        end
      end
      terminate_interaction 1
    end

    changelog_path = File.join(spec.gem_dir, changelog_file)
    if options[:lines]
      show_first_lines(changelog_path, options[:lines])
    else
      system(pager, changelog_path)
    end
  end

  def usage
    "#{program_name} GEM_NAME"
  end

  def arguments
    'GEM_NAME      name of the gem to show'
  end

  def find_changelog_file(spec)
    files(spec.gem_dir).sort.find {|file| CHANGELOG_RE === file }
  end

  def show_first_lines(file_path, number=10)
    open file_path do |file|
      puts file.each_line.take(number)
    end
  end

  private

  CHANGELOG_RE = Regexp.union(/\ACHANGELOG\b/i, /\ACHANGES\b/i, /\AHistory\b/i)

  def files(dir)
    Dir.entries(dir).select {|e| FileTest.file?(File.join(dir, e)) }
  end

  def pager
    ENV['PAGER'] || 'more'
  end
end
