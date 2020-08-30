#!/usr/bin/env ruby
# Parse Arlington GIS assessment, property, zoning info into .json
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

module AssessorParser
  VERSION = '0.1g'
  DESCRIPTION = <<-HEREDOC
  AssessorParser: Parse ArlingtonMA Assess CSV file into indexed hash, and create 
    various other ownership or zoning related data hashes 
  Sample usage:
  - Download ArlingtonMA_Assess.csv and ArlingtonMA_Zoning.csv 
    - from http://gis-arlingtonma.opendata.arcgis.com/search?tags=property
    - into arlingtonma.info/dld
  - Run this program like so, in order:
    ruby src/AssessorParser.rb -a    (Generates dld/ArlingtonMA_Assess.json)
    ruby src/AssessorParser.rb -z    (Generates docs/data/property/ArlingtonMA_Zoning.json)
    ruby src/AssessorParser.rb -g    (Generates docs/data/property/ArlingtonMA_TopOwners.json)
  HEREDOC
  extend self
  require 'csv'
  require 'json'
  require 'set'
  require 'optparse'
  
  ID = 'PROP_ID'
  OWNER = 'OWNER1'
  SITE_ADDR = 'SITE_ADDR'
  TOTAL_VAL = 'TOTAL_VAL'
  LOT_SIZE = 'LOT_SIZE'
  USE_CODE = 'USE_CODE'
  ZONING = 'ZONING'
  VAL = 'val'
  SIZE = 'size'
  SIZE_OFFSET = 0
  VAL_OFFSET = 1
  PARCELS = 'parcels'
  ZONES = 'zones'
  ROUND_TO = 4 # Rounding lot sizes in ownership
  NUM_TOP = 100 # How many top owners to output
  OWNER_MAP = { # From corporate ownership records, mapping beneficial or effective ownership for selected town or developer properties
    "TOWN OF ARLINGTON PARK" => "Town Of Arlington",
    "TOWN OF ARLINGTON SCHOOL" => "Town Of Arlington",
    "TOWN OF ARLINGTON" => "Town Of Arlington",
    "DEPT/CONSERVATION & RECREATION" => "Town Of Arlington",
    "TOWN OF ARLINGTON CEMETERY" => "Town Of Arlington",
    "TOWN OF ARLINGTON CON COM" => "Town Of Arlington",
    "TOWN OF ARLINGTON-PARK" => "Town Of Arlington",
    "TOWN OF ARLINGTON TOWN YARD" => "Town Of Arlington",
    "TOWN OF ARLINGTON TAX POSS" => "Town Of Arlington",
    "TOWN OF ARLINGTON SELECTMEN" => "Town Of Arlington",
    "TOWN OF ARLINGTON TOWN HALL" => "Town Of Arlington",
    "TOWN OF ARLINGTON LIBRARY" => "Town Of Arlington",
    "TOWN OF ARLINGTON WELFARE" => "Town Of Arlington",
    "TOWN OF ARLINGTON CHAP 111" => "Town Of Arlington",
    "TOWN OF ARLINGTON FIRE DEPT" => "Town Of Arlington",
    "TOWN OF ARLINGTON FIRE STA" => "Town Of Arlington",
    "TOWN OF ARLINGTON PARK DEPT" => "Town Of Arlington",
    "TOWN OF ARLINGTON PARK LOT" => "Town Of Arlington",
    "TOWN OF ARLINGTON-PARK DEPT" => "Town Of Arlington",
    "400-402 MASS AVE LLC" => "Frank Pasciuto",
    "2-14 MEDFORD STREET LLC" => "Frank Pasciuto",
    "882-892 MASSACHUSETTS AVENUE" => "Frank Pasciuto",
    "PASCIUTO  FRANK/FERMINA" => "Frank Pasciuto",
    "FRAMINA LLC" => "Frank Pasciuto",
    "DOHERTY JAMES F" => "James F. Doherty",
    "DOHERTY JAMES F/TRUSTEE" => "James F. Doherty",
    "MIRAK JOHN TR" => "Mirak Family",
    "MIRAK CHARLES/ROBERT/EDWARD" => "Mirak Family",
    "MIRAK ROBERT/CHARLES/EDWARD" => "Mirak Family",
    "MIRAK TRUCK CENTER LLC" => "Mirak Family",
    "MIRAK-BENDETSON DEV LLC" => "Mirak Family",
    "YUKON REALTY LLC" => "Mirak Family",
    "ARLINGTON CENTER GARAGE &" => "Mirak Family",
    "ARLINGTON CENTER  GARAGE" => "Mirak Family",
    "ARLINGTON CENTER GARAGE" => "Mirak Family",
    "P&M CARUSO FAMILY LLC" => "Paul Caruso",
    "CARUSO PAUL & MARIA A" => "Paul Caruso",
    "JASON TERRACE LLC" => "Henry E. Davidson, Jr.",
    "DAVIDSON MANAGEMENT" => "Henry E. Davidson, Jr.",
    "DAVIDSON HENRY E TRS-ETAL" => "Henry E. Davidson, Jr.", # Not confirmed from corporation records, but shares address/name
    "ARLINGTON LAND REALTY LLC" => "Mugar Family"
  }
  
  # Parse CSV assessor file to hash
  # @param f filename to read
  # @return data[0] of status information; data[1] of csv hashified 
  def parse_assess(f)
    data = []
    data << { id: f, version: VERSION, generated: "#{Time.now}" }
    data << {}
    CSV.foreach(f, headers: true) do |row|
      data[1][row[ID]] = {}
      row.each do |k,v|
        data[1][row[ID]][k] = v
      end
    end
    return data
  end
  
  # Parse CSV zoning area file to hash
  # @param f filename to read
  # @return data[0] of status information; data[1] of csv hashified 
  def parse_zoning(f)
    data = []
    data << { id: f, version: VERSION, generated: "#{Time.now}"  }
    zones = {}
    CSV.foreach(f, headers: true) do |row|
      zname = row['ZoneAbbr'].strip
      next if zname.empty?
      if zones.has_key?(zname)
        zones[zname] += row['Acres'].to_f
      else
        zones[zname] = row['Acres'].to_f
      end
    end
    data << zones.sort.to_h # Ensure output file has a stable order of Zone name
    return data
  end
  
  # Create crossindex of owner name to property id 
  # @param assessor hash to read
  # @return hash of owner names with lists of properties owned
  # Passed to sumup_owners() to then output ArlingtonMA_Owners.json full list
  def crossindex_owners(data)
    records = data[1]
    owners = {}
    records.each do |id, record|
      tmp = {}
      [ SITE_ADDR, USE_CODE, ZONING ].each do |fld|
        tmp[fld] = record[fld]
      end
      tmp[TOTAL_VAL] = record[TOTAL_VAL].to_i
      tmp[LOT_SIZE] = record[LOT_SIZE].to_f
      owner = OWNER_MAP.fetch(record[OWNER], record[OWNER])
      owners.has_key?(owner) ? owners[owner][PARCELS][id] = tmp : owners[owner] = { PARCELS => { id => tmp } }
    end
    return owners
  end
  
  # Sum up crossindex for owners with multiple properties  
  # @param owners hash to annotate; @sideeffect adds fields
  # @return owners hash for chaining
  #   ArlingtonMA_Owners.json: { parcels: {...}, val, size, zones: { zone: [size, val], ...}}
  def sumup_owners(owners)
    owners.each do |owner, owned|
      val = 0
      size = 0
      zones = {}
      owned[PARCELS].each do |k, property|
        val += property[TOTAL_VAL]
        size += property[LOT_SIZE]
        if zones.has_key?(property[ZONING])
          zones[property[ZONING]][SIZE_OFFSET] += property[LOT_SIZE]
          zones[property[ZONING]][VAL_OFFSET] += property[TOTAL_VAL]
        else
          zones[property[ZONING]] = [property[LOT_SIZE], property[TOTAL_VAL]]
        end
      end
      owned[VAL] = val
      owned[SIZE] = size.round(ROUND_TO)
      owned[ZONES] = zones
    end
    return owners
  end

  # Find top X owners by value, size, or parcels, and by %age of total zoned land types
  # @param owners hash 
  # @param zones total acres per zoning type
  # @param num of top owners to output 
  # @return TopOwners hasn with just comparison data by parcels/size/value
  #   ArlingtonMA_TopOwners.json: { parcels: {owner: count,...}, size: {owner: {size: acres, B2: percent of zoneB2},...}, val: {owner: v},...}
  def top_owners(owners, zones, max)
    valsize = {VAL => {}, PARCELS => {}, SIZE => {}}
    ctr = 0
    val = owners.sort_by { |owner, hash| -hash[VAL] }
    val.each do |owner, hash|
      valsize[VAL][owner] = hash[VAL]
      ctr += 1
      break if ctr > max
    end
    ctr = 0
    parcels = owners.sort_by { |owner, hash| -hash[PARCELS].size }
    parcels.each do |owner, hash|
      valsize[PARCELS][owner] = hash[PARCELS].size
      ctr += 1
      break if ctr > max
    end
    ctr = 0
    size = owners.sort_by { |owner, hash| -hash[SIZE] }
    size.each do |owner, hash|
      valsize[SIZE][owner] = {}
      valsize[SIZE][owner][SIZE] = hash[SIZE]
      hash[ZONES].each do |z, acres|
        valsize[SIZE][owner][z] = (acres[SIZE_OFFSET] / zones[z]).round(ROUND_TO) if zones.has_key?(z) # Note: oddly, some parcels have null for ZONING
      end
      ctr += 1
      break if ctr > max
    end
    return valsize
  end

  # Find top X owners per zoned land type
  # @param owners hash 
  # @param zones total acres per zoning type
  # @param num of top owners to output 
  # @return TopZoneOwners hasn with just comparison data per zoning area
  #   ArlingtonMA_TopZoneOwners.json: {  TBD  }
  def top_zone_owners(owners, zones, max)
    valsize = {VAL => {}, SIZE => {}}
    ctr = 0
    zones.each do |zone, unused|
      valsize[VAL][zone] = {}
      val = owners.sort_by { |owner, hash| - (hash[ZONES].has_key?(zone) ? hash[ZONES][zone][VAL_OFFSET] : 0) }
      ctr = 0
      val.each do |owner, hash|
        break unless hash[ZONES].has_key?(zone)
        valsize[VAL][zone][owner] = hash[ZONES][zone][VAL_OFFSET]
        ctr += 1
        break if ctr > max
      end

      valsize[SIZE][zone] = {}
      val = owners.sort_by { |owner, hash| - (hash[ZONES].has_key?(zone) ? hash[ZONES][zone][SIZE_OFFSET] : 0) }
      ctr = 0
      val.each do |owner, hash|
        break unless hash[ZONES].has_key?(zone)
        acres = hash[ZONES][zone][SIZE_OFFSET]
        valsize[SIZE][zone][owner] = [ acres.round(ROUND_TO), (acres / zones[zone]).round(ROUND_TO) ]
        ctr += 1
        break if ctr > max
      end
    end
    return valsize
  end

  # Compare total acreage per zone with official zone record
  # @param owners hash 
  # @param zones total acres per zoning type
  # @param num of top owners to output 
  # @return hash comparison by zone, with listing of properties with zonenull or zonemissing
  def sum_zones(owners, zones)
    zonecomp = { 'zonenull' => {}, 'zonemissing' => {} }
    ctr = 0
    zones.each do |zone, zsize|
      zonecomp[zone] = [zsize, 0]
    end
    owners.each do |owner, hash|
      hash[PARCELS].each do |parcel, phash|
        if phash[ZONING]
          zonecomp.has_key?(phash[ZONING]) ? zonecomp[phash[ZONING]][1] += phash[LOT_SIZE] : zonecomp['zonemissing'][parcel] = [phash[ZONING], phash[LOT_SIZE]]
        else
          zonecomp['zonenull'][parcel] = phash[LOT_SIZE]
        end
      end
    end
    return zonecomp
  end

  # Bottleneck pretty JSON output
  # @param data to output
  # @param path/filename to output
  # @param sort if we should data.sort.to_h
  def output_json(data, file, sort)
    puts "Outputting file: #{file}"
    File.open("#{file}", "w") do |f|
      f.puts JSON.pretty_generate(sort ? data.sort.to_h : data)
    end
  end
 
  # ## ### #### ##### ######
  # Check commandline options
  def parse_commandline
    options = {}
    OptionParser.new do |opts|
      opts.on('-h', '--help', 'Print help for this program') { puts "#{DESCRIPTION}\n#{opts}"; exit }
      # Various inputs/outputs or options
      opts.on('-iINPUT', '--input INPUTFILE', 'Input filename use for current operation, if different than default') do |input|
        if File.file?(input)
          options[:input] = input
        else
          raise ArgumentError, "-i #{input} is neither a valid file nor an apparent URL"
        end
      end
      opts.on('-oZONING.JSON', '--zones ZONING.JSON', 'Input filename for zoning totals (default: dld/ArlingtonMA_Zoning.json)') do |zoning|
        if File.file?(zoning)
          options[:zoning] = zoning
        else
          raise ArgumentError, "-i #{zoning} is neither a valid file nor an apparent URL"
        end
      end
     
      opts.on('-oOUTFILE.JSON', '--out OUTFILE.JSON', 'Output filename to write parsed data (default: property/ArlingtonMA_subname.json)') do |out|
        options[:out] = out
      end
      opts.on('-a', 'Parse an ArlingtonMA_Assess.csv file into ArlingtonMA_Assess.json') do |assess|
        options[:assess] = true
      end
      opts.on('-z', 'Parse an ArlingtonMA_Zoning.csv file to sum up total area into ArlingtonMA_Zoning.json') do |zone|
        options[:zone] = true
      end
      opts.on('-g', 'Parse ArlingtonMA_Assess.json and ArlingtonMA_Zoning.json file and generate ArlingtonMA_Owners.json and other data.') do |generate|
        options[:generate] = true
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
    if options.has_key?(:assess) # Just process downloaded assessor file
      options[:input] ||= "dld/ArlingtonMA_Assess.csv"
      options[:out] ||= "dld/ArlingtonMA_Assess.json"
      output_json(parse_assess(options[:input]), options[:out], false)

    elsif options.has_key?(:zone) # Just process downloaded zoning file
      options[:input] ||= "dld/ArlingtonMA_Zoning.csv"
      options[:out] ||= "docs/data/property/ArlingtonMA_Zoning.json"
      output_json(parse_zoning(options[:input]), options[:out], false)

    elsif options.has_key?(:generate) # Generate our data from pre-processed files
      options[:input] ||= "dld/ArlingtonMA_Assess.json"
      options[:owners] ||= "dld/ArlingtonMA_Owners.json"
      options[:topowners] ||= "docs/data/property/ArlingtonMA_TopOwners.json"
      options[:topzowners] ||= "docs/data/property/ArlingtonMA_TopZOwners.json"
      options[:zonecomp] ||= "docs/data/property/ArlingtonMA_ZoneComp.json"
      options[:zoning] ||= "docs/data/property/ArlingtonMA_Zoning.json"
      owners = crossindex_owners(JSON.parse(File.read(options[:input])))
      output_json(sumup_owners(owners), options[:owners], true)
      zones = JSON.parse(File.read(options[:zoning]))
      output_json(top_owners(owners, zones[1], NUM_TOP), options[:topowners], true)
      output_json(top_zone_owners(owners, zones[1], NUM_TOP), options[:topzowners], true)
      output_json(sum_zones(owners, zones[1]), options[:zonecomp], true)

    else
      puts "Please specify an option, use -h for help."
    end
  end
end
