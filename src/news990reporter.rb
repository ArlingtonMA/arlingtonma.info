#!/usr/bin/env ruby
module News990Reporter
  DESCRIPTION = <<-HEREDOC
  News990Reporter: build simple reports about nonprofit news orgs
  HEREDOC
  module_function
  require 'json'
  require 'csv'
  require 'yaml'
  require 'faraday' # open-uri does not work in this script, which is quite a mystery
  require '../../propublica990/propublica990'

  P990_DIR = '../docs/data/newsorgs/p990' # HACK, assumes run from script dir
  NEWSORGS_DIR = '../docs/_newsorgs'
  DEM_CSV = '../docs/data/demographics/ma-dls-incomepercapita-2023.csv'
  DEMOGRAPHIC_FIELDS = {
    'municipality' => 'Municipality',
    'population' => 'Population',
    'incomepercapita' => 'DORIncomePerCapita',
    'eqvpercapita' => 'EQVPerCapita'
  }
  MANUAL_FINANCE = {
    '874640985' => {
      'ein' => '874640985',
      'tax_prd_yr' => '2023',
      'tax_prd' => 'N/A estimates',
      'formtype' => 'https://docs.google.com/presentation/d/1yS2ydBaYr8r4NOdxLFud7sX5ud6B0Bq6zQJy8_8-Qd0/edit#slide=id.g11a7a6660d9_0_17',
      'totcntrbgfts' => 43564,
      'invstmntinc' => 'N/D',
      'totprgmrevnue' => 'N/D',
      'totrevenue' => 157032,
      'totfuncexpns' => 156981,
      'totassetsend' => 'N/D',
      'totliabend' => 'N/D',
      'totnetassetend' => 'N/D'
    },
    '882367192' => {
      'ein' => '882367192',
      'tax_prd_yr' => '2022',
      'tax_prd' => 'N/A estimates',
      'formtype' => 'https://marbleheadcurrent.org/wp-content/uploads/2023/11/2022-Current-Annual-Report-7.pdf',
      'totcntrbgfts' => 31077,
      'invstmntinc' => 'N/D',
      'totprgmrevnue' => 17207,
      'totrevenue' => 153348,
      'totfuncexpns' => 76314,
      'totassetsend' => 'N/D',
      'totliabend' => 'N/D',
      'totnetassetend' => 'N/D'
    },
    '871248884' => {
      'ein' => '871248884',
      'tax_prd_yr' => '2023',
      'tax_prd' => 'N/A estimates',
      'formtype' => 'Google Drive',
      'totcntrbgfts' => 45000,
      'invstmntinc' => 500,
      'totprgmrevnue' => 0,
      'totrevenue' => 75000,
      'totfuncexpns' => 67000,
      'totassetsend' => 'N/D',
      'totliabend' => 'N/D',
      'totnetassetend' => 30000
    },
    '920697644' => {
      'ein' => '920697644',
      'tax_prd_yr' => '2022',
      'tax_prd' => 'MA AGO PC form',
      'formtype' => 'https://masscharities.my.site.com/FilingSearch/s/detail/a0B4U00001ANpmkUAD',
      'totcntrbgfts' => 6624,
      'invstmntinc' => 0,
      'totprgmrevnue' => 0,
      'totrevenue' => 9013,
      'totfuncexpns' => 2994,
      'totassetsend' => 'N/D',
      'totliabend' => 'N/D',
      'totnetassetend' => 6019
    },
    '473575404' => {
      'ein' => '473575404',
      'tax_prd_yr' => '2022',
      'tax_prd' => 'MA AGO PC form',
      'formtype' => 'https://masscharities.my.site.com/FilingSearch/s/detail/a0B4U00001CLpOAUA1',
      'totcntrbgfts' => 22715,
      'invstmntinc' => 0,
      'totprgmrevnue' => 0,
      'totrevenue' => 22715,
      'totfuncexpns' => 23375,
      'totassetsend' => 'N/D',
      'totliabend' => 'N/D',
      'totnetassetend' => 13969
    }
  }

  # Read current demographics table for Massachusetts
  # @param path/filename of ma-dls-incomepercapita-2023.csv
  # @return hash of { townname => {...}, ... }
  def read_demographics(filename)
    table = CSV.new(File.read(filename), :headers => true, :converters => :all)
    demographics = {} # ALTERNATE: return table.to_a.map {|row| row.to_hash }
    table.each_with_object({}) do |row, hash|
      demographics[row['Municipality']] = row.to_h
    end
    return demographics
  end

  # Read all news orgs; return all that have eins listed
  # @param dir to find .md files in
  # @return hash of { ein => YAML-metadata, ... }
  def read_newsorgs(dir)
    orgs = {}
    Dir["#{dir}/**/*.md"].each do |f|
      org = YAML.load(File.read(f), aliases: true)
      ein = org['taxID']
      if ein
        ein = ein.sub('-', '')
        orgs[ein] = org
      end
    end
    return orgs
  end

  REPORT_HEADERS = %w[ ein commonName location irsdate population incomepercapita eqvpercapita EIN Tax_Year Tax_Period_End Form_Type_Filed Contributions Investment_Income Program_Service_Revenue Total_Revenue Total_Expenses Total_Assets Total_Liabilities Net_Assets contribpercapita revpercapita expensepercapita]
  # Annotate a row of data with calculated values; side effects
  # @param row to mutate by adding new hash items
  def annotate_row(row)
    pop = row['population'].to_f
    ipc = row['incomepercapita'].to_f
    contrib = row['Contributions'].to_f
    exp = row['Total Expenses'].to_f
    rev = row['Total Revenue'].to_f
    row['contribpercapita'] = (contrib / pop).round(2)
    row['revpercapita'] = (rev / pop).round(2)
    row['expensepercapita'] = (exp / pop).round(2)
    return row
  end

  # Generate a simple csv report of local detailed comparisons (where data available)
  def generate_report(orgs, p990s, demographics)
    report = []
    orgs.each do |ein, org|
      pp = p990s[ein]
      next if pp.nil?
      location = org['location'] # TODO handle orgs serving two or more localities
      demographic = demographics[location]
      next if demographic.nil?
      # Calculate various data
      row = {}
      row['ein'] = ein.to_s
      row['commonName'] = org['commonName']
      row['location'] = location
      row['irsdate'] = pp['organization']['ruling_date']
      row['population'] = demographic['Population'].sub(',', '')
      row['incomepercapita'] = demographic['DORIncomePerCapita'].sub(',', '')
      row['eqvpercapita'] = demographic['EQVPerCapita'].sub(',', '')
      filing = Propublica990.get_latest_filing(pp, MANUAL_FINANCE.fetch(ein, nil))
      if filing
        filing.shift # Drop the first id element, which is not in the MAP_ # TODO should normalize to which fieldnames we want in various places
        vals = FieldMap990::MAP_990_COMMON.values
        filing.each_with_index do | elem, i |
          row[vals[i]] = elem
        end
      else
        row['totfuncexpns'] = 'ERROR: could not fetch latest filing data'
      end
      report << annotate_row(row)
    end
    return report
  end

  REPORT_HEADERS_ALL = %w[ commonName website irsdate population location state EIN Tax_Year Tax_Period_End Form_Type_Filed Contributions Investment_Income Program_Service_Revenue Total_Revenue Total_Expenses Total_Assets Net_Assets contribpercapita revpercapita expensepercapita]
  # Annotate a row of data with calculated values; side effects
  # @param row to mutate by adding new hash items
  def annotate_row_all(row)
    pop = row['population'].to_f
    contrib = row['Contributions'].to_f
    exp = row['Total Expenses'].to_f
    rev = row['Total Revenue'].to_f
    row['contribpercapita'] = (contrib / pop).round(3)
    row['revpercapita'] = (rev / pop).round(3)
    row['expensepercapita'] = (exp / pop).round(3)
    return row
  end

  # Generate a simplistic report from all orgs
  def generate_report_all(orgs, p990s)
    report = []
    orgs.each do |ein, org|
      pp = p990s[ein]
      next if pp.nil?
      next unless pp.is_a?(Hash)
      location = org['location'] # TODO handle orgs serving two or more localities
      demog = org.fetch('demographics', nil) # FIXME these are not exactly the same figure everywhere
      next unless demog
      # Calculate various data
      row = {}
      row['commonName'] = org['commonName']
      row['website'] = org['website']
      row['irsdate'] = pp['organization']['ruling_date']
      row['population'] = demog['population']
      filing = Propublica990.get_latest_filing(pp, MANUAL_FINANCE.fetch(ein, nil))
      if filing
        filing.shift # Drop the first id element, which is not in the MAP_ # TODO should normalize to which fieldnames we want in various places
        vals = FieldMap990::MAP_990_COMMON.values
        filing.each_with_index do | elem, i |
          row[vals[i]] = elem # FIXME this section doesn't always line up field values in columns...
        end
      else
        row['totfuncexpns'] = 'ERROR: could not fetch latest filing data'
      end
      report << annotate_row_all(row)
    end
    return report
  end

  # Attempt to search  Propublica based on corporate name and state
  # @return hash listing of potential matches; requires manual review
  def search_propublica(name, state)
    begin
      propublica = Faraday.new(url: 'https://projects.propublica.org/')
      urlbase = "nonprofits/api/v2/search.json?q=#{name.gsub(' ', '+')}&state[id]=#{state}"
      # Actual working URL: https://projects.propublica.org/nonprofits/api/v2/search.json?q=canopy+atlanta&state%5Bid%5D=GA
      # 500 error url:      https://projects.propublica.org/nonprofits/api/v2/search.json?q=AfroLA&state=%5Bid%5D%3DCA
      # query = "?q=#{name.gsub(' ', '+')}&state[id]=#{state}" # Using this in Faraday encodes the state[id]=CA part wrong
      response = propublica.get(urlbase)
      return JSON.load(response.body)
    rescue StandardError => e
      puts "ERROR: search_propublica(#{name}): #{e.message}\n\n#{e.backtrace.join("\n\t")}"
      return nil
    end
  end

  # Printout potential match status
  def print_propublica_match(name, data)
    results = data['total_results']
    if results == 0
      puts "XNo org found: #{name}"
    elsif results == 1
      org = data['organizations'].first
      puts "Likely org found: #{name} maybe: EIN: #{org['strein']} for: #{org['name']}"
    else
      puts "Multiple orgs found for: #{name}"
      data['organizations'].each do | org |
        puts "  EIN: #{org['strein']} for: #{org['name']}"
      end
    end
  end

  # Lookup all orgs without EINs in Propublica's nonprofit explorer and return potential matches
  # @return hash of all potential matching orgs
  def lookup_propublica(dir)
    matches = {}
    Dir["#{dir}/**/*.md"].each do |f|
      identifier = File.basename(f, '.md')
      org = YAML.load(File.read(f), aliases: true)
      tid = org.fetch('taxID', '')
      state = org.fetch('state', '')
      legalName = org.fetch('legalName', '')
      # puts "lookup_propublica(): #{tid}, #{state}, #{legalName} -- -- --"
      next if tid && tid.length > 2
      next if state.nil?
      next if state.length < 1
      next if legalName.nil?
      next if legalName.length < 2
      p = search_propublica(legalName, state)
      if p
        matches[identifier] = p
        print_propublica_match(identifier, p)
      end
    end
    return matches
  end

  # ### #### ##### ######
  # Main method for command line use
  if __FILE__ == $PROGRAM_NAME
    orgs = read_newsorgs(NEWSORGS_DIR)
    # fn = DEM_CSV
    # demographics = read_demographics(fn)

    # Forall eins available, download propublica data
    orgs = read_newsorgs(NEWSORGS_DIR)
    p990s = Propublica990.get_orgs(orgs.keys, P990_DIR)
    p990s.each do | k, v |
      if k.is_a?(String) # get_orgs returns errors as strings, not hashes
        puts k
      end
    end
    puts "Done!"
    # For all orgs we have data for, create CSV
    # csvfile = 'news-finances-all.csv'
    # p990s = Propublica990.get_orgs(orgs.keys, P990_DIR)
    # # Propublica990.orgs2csv_common(p990s, csvfile)
    # report = generate_report_all(orgs, p990s)
    # puts JSON.pretty_generate(report[3])
    # puts JSON.pretty_generate(report[4])
    # CSV.open(csvfile, "w") do |csv|
    #   csv << REPORT_HEADERS_ALL
    #   report.each do | r |
    #     csv << r.values
    #   end
    # end
    # matches = lookup_propublica(dir)
    # File.open("news990reporter.json", 'w') do |f|
    #   f.puts JSON.pretty_generate(matches)
    # end
  end
end
