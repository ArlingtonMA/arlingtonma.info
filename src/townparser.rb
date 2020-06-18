#!/usr/bin/env ruby
# Screen scrape various Arlington town CMS web pages into json structures
# Copyright (c) 2020 Shane Curcuru
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module TownParser
  DESCRIPTION = <<-HEREDOC
  TownParser: Parse simple town CMS webpages into JSON listings of links
  Sample usage:
  ruby src/townparser.rb -i https://www.arlingtonma.gov/departments/town-manager/town-manager-s-annual-budget-financial-report 
  HEREDOC
  extend self
  require 'json'
  require 'optparse'
  require 'nokogiri'
  require 'open-uri'
  require 'net/http'
  require 'uri'
  
  # Parse a town web page and output array of hashes of all major links on the page
  # This does not attempt to reproduce the page, only provide key href/title links
  # @param io stream to read
  # @param id identifier of stream (filename or URL)
  # @param parentid for anchors
  # @return data hash listing links; includes AgendaUtils::ERROR key if any
  def parse(io, id, parentid)
    data = {}
    begin
      doc = Nokogiri::HTML(io)
      data = {}
      data['parentid'] = parentid
      data['items'] = {}
      nodes = []
      # Read .breadcrumb for inner list of <a href=...
      data['items']['breadcrumb'] = {}
      nodes = doc.css('.breadcrumb a')
      nodes.each do |node|
        parse_node(node, data['items']['breadcrumb'])
      end
      # Read nav[.sidenav] for mobile-only short listing of links - <nav id='leftNav_6_0_372' class='nocontent sidenav mobile_list vi-sidenav-desktop   '>
      data['items']['sidenav'] = {}
      nodes = doc.css('.sidenav ul')
      nodes.each do |node|
        parse_node(node, data['items']['sidenav'])
      end
      # Read nav[.mainnav] for normal left-hand menu structure (nested) <nav class="regularmegamenu mainnav" id="menuContainer_5_0_372">
      data['items']['mainnav'] = {}
      nodes = doc.css('.mainnav > ul')
      nodes.each do |node|
        parse_node(node, data['items']['mainnav'])
      end
      # Read main content of page and scan for links
      data['items']['content'] = {}
      nodes = doc.css('.content_area a')
      nodes.each do |node|
        parse_node(node, data['items']['content'])
      end
      # TODO parse random links in main content of page
    rescue StandardError => e
      data['error'] = "#{id} #{e.message}"
      data['stack'] = e.backtrace.join("\n\t")
    end
    return data
  end
  
  # Recursively parse contents of ul recursively
  # @param node to parse
  # @param data hash to fill with relevant stuff
  # Note: Skips javascript: links
  def parse_node(node, data)
    return if node.text?
    case node.name
    when 'a'
      return if /javascript:/ =~ node['href']
      data[node['href']] = node.content.strip
    when 'li'
      # Grab our immediate links
      links = node.css('> a')
      links.each do |link|
        parse_node(link, data)
      end
      # Grab any child ul lists
      sublists = node.css('ul')
      sublists.each do |sublist|
        parse_node(sublist, data)
      end
    when 'ul' # TODO preserve structure with sub-levels
      items = node.css('> li')
      items.each do |item|
        parse_node(item, data)
      end
    else
    end
  end
  
  # ## ### #### ##### ######
  # Check commandline options
  def parse_commandline
    options = {}
    OptionParser.new do |opts|
      opts.on('-h', '--help', 'Print help for this program') { puts "#{DESCRIPTION}\n#{opts}"; exit }
      # Various inputs/outputs or options
      opts.on('-iINPUT', '--input INPUTFILE', 'Input filename  or http... url to use for current operation') do |input|
        if File.file?(input)
          options[:ioname] = input
          options[:input] = File.read(options[:ioname])
        elsif /http/ =~ input
          options[:ioname] = input
          options[:input] = open(options[:ioname])
        else
          raise ArgumentError, "-i #{input} is neither a valid file nor an apparent URL"
        end
      end
      opts.on('-oOUTFILE.JSON', '--out OUTFILE.JSON', 'Output filename to write parsed data (default: townparser.json)') do |out|
        options[:out] = out
      end

      begin
        opts.parse!
        # Instead of error here, attempt to provide sensible defaults below
      rescue OptionParser::ParseError => e
        $stderr.puts e
        $stderr.puts opts
        exit 1
      end
    end
    return options
  end
  
  # ### #### ##### ######
  # Main method for command line use
  if __FILE__ == $PROGRAM_NAME
    options = parse_commandline
    options[:ioname] ||= "townparser.html"
    options[:input] ||= File.read(options[:ioname])
    options[:out] ||= "townparser.json"
    links = parse(options[:input], options[:ioname], 'roottest')
    puts "Outputting file #{options[:out]}"
    File.open("#{options[:out]}", "w") do |f|
      f.puts JSON.pretty_generate(links)
    end
  end
end
