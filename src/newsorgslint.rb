#!/usr/bin/env ruby
module NewsorgsLint
  DESCRIPTION = <<-HEREDOC
  NewsorgsLint: Simplistic linting for newsorgs.md files
  HEREDOC
  module_function
  require 'yaml'
  require 'json'

  NEWSORGS_DIR = '../docs/_newsorgs'

  # Normalize a newsorgs file's yaml, leaving markdown content as-is
  # Side effect: writes file back to same location; may lose comments or formatting data
  # @return a string describing what we did, or error string
  def normalize_md(filename)
    begin
      yaml_sep = '---'
      data = File.read(filename)
      _unused, frontmatter, markdown = data.split(yaml_sep, 3) # YAML data separator
      markdown = '' if markdown.nil?
      yaml = YAML.safe_load(frontmatter, aliases: true)
      yaml.delete('identifier_hack')
      # Delete scanned data if we already have an ein
      ein = yaml.fetch('taxID', nil)
      if ein && ein.length > 8
        yaml.delete('einscan')
        yaml.delete('nonprofit')
        yaml.delete('legalName_hack')
      end
      # Normalize links arrays
      %w[boardurl policyurl teamurl missionurl donateurl contributeurl sponsorurl advertising contactUs ].each do | key |
        item = yaml.fetch(key, nil)
        if item
          if item.is_a?(String)
            yaml[key] = '' if /\A(\\)?#\z/.match(item) # TODO would we want to normalize to absolute URLs?
          elsif item.is_a?(Array)
            item.reject!{ |v| /\A(\\)?#\z/.match(v) }
            if item.length == 0
              yaml[key] = ''
            elsif item.length == 1
              yaml[key] = yaml[key].first
            else
              # TODO: No-op, just leave as array for now?
            end
          end
        end
      end
      # Simplify webcms
      generator = yaml.fetch('webgenerator', nil)
      if generator
        yaml['webgenerator'] = nil if "[]".eql?(generator)
        yaml['websitecms'] = 'WP' if generator.include?('WordPress')
        yaml['websitecms'] = 'WP,SiteKit' if generator.include?('Site Kit by Google')
      end
      # Dump our normalized data back to a file; note this removes # comments
      output = yaml.to_yaml
      output << yaml_sep # Note: newline provided by shovel operator below
      output << markdown
      outputfilename = filename
      File.open(outputfilename, 'w') do |f|
        f.puts output
      end
      return "Wrote out: #{outputfilename}"
    rescue StandardError => e
      return "ERROR: normalize_md(#{filename}): #{e.message}\n\n#{e.backtrace.join("\n\t")}"
    end
  end

  # Normalize all our md files; return report of what's done
  # @return array of strings describing each action
  def normalize_mds(dir)
    report = []
    Dir["#{dir}/**/*.md"].each do |f|
      report << normalize_md(f)
    end
    return report
  end

  # ### #### ##### ######
  # Main method for command line use
  if __FILE__ == $PROGRAM_NAME
    dir = NEWSORGS_DIR
    report = normalize_mds(dir)
    puts JSON.pretty_generate(report)
  end
end
