#!/usr/bin/env ruby
# Read mass.gov corporate record page HTML into JSON listing(s)
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

module CorporationParser
  DESCRIPTION = <<-HEREDOC
  CorporationParser: Parse a mass.gov corporate record
  - Manually search for a single corporate record here:
  http://corp.sec.state.ma.us/CorpWeb/CorpSearch/CorpSearch.aspx
  - Save the *single* record as a 123456789.html file in dld/corporations
  - Run ruby corporationparser.rb (processes all files in dir by default)
  HEREDOC
  extend self
  require 'nokogiri'
  require 'open-uri'
  require 'net/http'
  require 'uri'
  require 'json'
  require 'optparse'
  require 'set'
  
  MASSGOV_CORP = 'http://corp.sec.state.ma.us/CorpWeb/CorpSearch/CorpSummary.aspx?sysvalue=' # Default base URL if you just pass gs_* data
  CORPID = 'id'
  AGENT_NAME = 'aname'
  ALL_NAMES = 'names'
  PARSED = 'parsed'
  ERROR = 'error'
  STACK = 'stack'
  FIELDS = { # HTML field id mapping to hash key
    'MainContent_lblIDNumberHeader' => CORPID,
    'MainContent_lblEntityNameHeader' => 'name',
    'MainContent_lblEntityName' => 'nameexact',
    'MainContent_lblEntityType' => 'orgtype',
    'MainContent_lblOrganisationDate' => 'orgdate',
    'MainContent_lblJurisdiction' => 'jurisdiction',
    'MainContent_lblRecStreet' => 'rstreet',
    'MainContent_lblRecCity' => 'rcity',
    'MainContent_lblRecState' => 'rstate',
    'MainContent_lblRecZip' => 'rzip',
    'MainContent_lblRecCountry' => 'rcountry',
    'MainContent_lblPrincipleStreet' => 'pstreet',
    'MainContent_lblPrincipleCity' => 'pcity',
    'MainContent_lblPrincipleState' => 'pstate',
    'MainContent_lblPrincipleZip' => 'pzip',
    'MainContent_lblPrincipleCountry' => 'pcountry',
    'MainContent_lblOfficeStreet' => 'ostreet',
    'MainContent_lblOfficeCity' => 'ocity',
    'MainContent_lblOfficeState' => 'ostate',
    'MainContent_lblOfficeZip' => 'ozip',
    'MainContent_lblOfficeCountry' => 'ocountry',
    'MainContent_lblResidentAgentName' => AGENT_NAME,
    'MainContent_lblResidentStreet' => 'astreet',
    'MainContent_lblResidentCity' => 'acity',
    'MainContent_lblResidentState' => 'astate',
    'MainContent_lblResidentZip' => 'azip',
    'MainContent_lblResidentCountry' => 'acountry',
    'MainContent_txtComments' => 'comments'
  }
  TABLES = { # HTML tables to parse for lists of names/addr
    'MainContent_tblManagers' => 'managers',
    'MainContent_grdOtherManagers' => 'filings',
    'MainContent_tblPersons' => 'signatories',
    'MainContent_grdOfficers' => 'officers',
    'MainContent_grdPartners' => 'partners'
  }

  # Parse a corporate record io stream and return hash of selected data
  # @param io to parse as html of the Business Entity Summary page
  # @return hash of selected data
  def parse(io)
    corp = {}
    doc = Nokogiri::HTML(io)
    maincontent = doc.css('div[role=main] table') # Content table holding info we need
    puts "#{__method__.to_s}() Parsing corporate table, children #{maincontent.children.length}"
    # All values are held in elements with IDs within this table
    FIELDS.each do |id, field|
      tmp = maincontent.css("##{id}").text.strip    
      corp[field] = tmp if not tmp.empty?
    end
    TABLES.each do |id, field|
      tmp = parse_table(maincontent.css("##{id}"))
      corp[field] = tmp if not tmp.empty?
    end
    scan_corp(corp)
    corp[PARSED] = "#{Time.now}"
    return corp
  end

  # Parse a potential list of names/addresses for managers, signatories, etc.
  # @param table <table> element to parse
  # @return hash of all tr[class=GridRow]... data
  def parse_table(table)
    listing = {} 
    table.css('tr.GridRow').each do |tr|
      begin
        cells = tr.css('td')
        name = cells[1].text.sub(' ', '').strip # Bogus char shows up in blank td's
        unless name.empty?
          listing[name] = {
            'addr' => cells[2].text.strip,
            'type' => cells[0].text.strip
          }
        end
      rescue StandardError => e
        data[ERROR] = "On: #{cells.inspect} Error: #{e.message}"
        data[STACK] = e.backtrace.join("\n\t")
      end
    end
    return listing
  end

  REGEX_JR = /[,]? JR[.]?/
  # Scan a record and aggregate data
  # NOTE: Normalizes spacing, and changes ', JR.' to ' JR'
  # @param corp hash of data to scan; side effect adds data
  # @return corp hash for chaining
  def scan_corp(corp)
    names = Set.new()
    names << corp[AGENT_NAME].upcase.sub(REGEX_JR, ' JR') if corp.has_key?(AGENT_NAME)
    TABLES.each do |id, field|
      if corp.has_key?(field)
        corp[field].keys.each do |key|
          names << key.upcase.gsub('  ', ' ').sub(REGEX_JR, ' JR') 
        end
      end
    end
    corp[ALL_NAMES] = names.to_a
    return corp
  end

  # Parse a directory full of downloaded ?????????.html corporation pages with ID as name
  # @param dir to scan
  # @param corp hash to fill in / overwrite
  # @return corp hash for chaining
  def parse_dir(dir, corp)
    Dir["#{dir}/?????????.html".untaint].each do |f|
      puts "Reading #{f}"
      tmp = parse(File.read(f.untaint))
      if tmp
        tmp[PARSED] = File.mtime(f)
        corp[tmp[CORPID]] = tmp
      end

    end
    return corp
  end

  # ## ### #### ##### ######
  # Check commandline options
  def parse_commandline
    options = {}
    OptionParser.new do |opts|
      opts.on('-h', '--help', 'Print help for this program') { puts "#{DESCRIPTION}\n#{opts}"; exit }
      # Various inputs/outputs or options
      opts.on('-iINPUT', '--input INPUTFILE', 'Input filename or http... url to use for current operation') do |input|
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
      opts.on('-dDIR', '--dir DIRECTORY', 'Directory of downloaded corporate.html files to parse') do |dir|
        if File.directory?(dir)
          options[:dir] = dir
        else
          raise ArgumentError, "-d #{dir} is not a valid directory, try again!"
        end
      end
      opts.on('-oOUTFILE.JSON', '--out OUTFILE.JSON', 'Output filename to add parsed data to (default: corporations.json)') do |out|
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
    options[:out] ||= "docs/data/corporations/corporations.json"
    options[:dir] ||= "dld/corporations"
    corporations = parse_dir(options[:dir], {})
    # Postprocess to collect meta-allnames
    names = Set.new()
    corporations.each do |id, hash|
      names.merge(hash[ALL_NAMES])
    end
    corporations[ALL_NAMES] = {
      PARSED => "#{Time.now}",
      ALL_NAMES => names.to_a.sort
    }
    puts "Outputting file #{options[:out]}"
    File.open("#{options[:out]}", "w") do |f|
      f.puts JSON.pretty_generate(corporations.sort.to_h)
    end
  end
end
