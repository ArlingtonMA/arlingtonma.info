#!/usr/bin/env ruby
module NPDetectpr
  DESCRIPTION = <<-HEREDOC
  NPDetector: Not Perfect Non Profit News (Paper) detector
    Scan urls and attempt to gather links or text blobs related
    to nonprofit status, governance, and other org factors
    Requires manual review of results!
  HEREDOC
  module_function
  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'yaml'
  require 'optparse'
  require 'csv'

  HACK_DO_ABOUT = true

  MODULE_LOG = [] # Simplistic logging if needed
  CACHE_SUBDIR = 'cache'
  ### Other parsing ideas
  # link rel="amphtml" provides AMP pages for Google?
  NORMALIZE_MAP = { # HACK normalize chars that drive me crazy
    ' ' => ' ',
    '’' => "'",
    '‘' => "'",
    '–' => '-'
  }
  NORMALIZE_PAT = /[ ’‘–]/
  SOCIAL_MAP = { # TODO update to capture just id's per service
    'twitter' => /twitter.com/i,
    'facebook' => /facebook.com/i,
    'instagram' => /instagram.com/i,
    'linkedin' => /linkedin.com/i,
    'tiktok' => /tiktok.com/i,
    'threads' => /threads.net/i,
    'bluesky' => /bsky.app/i,
    'youtube' => /youtube.com/i,
    'whatsapp' => /whatsapp.com/i,
    'snapchat' => /snapchat.com/i,
    'pinterest' => /pinterest.com/i,
    'reddit' => /reddit.com/i
  }
  CSS_MAP = {
    'slogan' => '.site-description',
    'copyright' => '.copyright',
    'imprint' => '.imprint'
  }
  TEXT_MATCHES = 'textmatch'
  EIN_SCAN = 'einscan'
  TEXTRX_MAP = {
    '501c3' => /501[(\s]*[c][)\s]*[(\s]*3[)\s]*/i,
    'nonprofit' => /non[-\s]?profit/i,
     # See https://www.irs.gov/businesses/small-businesses-self-employed/how-eins-are-assigned-and-valid-ein-prefixes
    EIN_SCAN => /(tax\s+id:?|ein:?)[\D]+(01|02|03|04|05|06|10|11|12|13|14|15|16|20|21|22|23|24|25|26|27|30|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|71|72|73|74|75|76|77|80|81|82|83|84|85|86|87|88|90|91|92|93|94|95|98|99|)[-]?\d{7}/i
  }
  METAS = 'metas'
  LINKS = 'links'
  NAVLINKS = 'linksnav'
  FOOTERLINKS = 'linksfooter'
  ALLLINKS = 'alllinks'
  SOCIALLINKS = 'social'
  ABOUT = 'aboutlinks'
  DONATE = 'donatelinks'
  LINKRX_MAP = {
    ABOUT => /\Aabout[-]?[u]?/i,
    'boardlinks' => /\Aboard/i, # others: Advisory, Community, Editorial, Our... Board ;Staff &/And Board
    'teamlinks' => /\A(meet|our|the)[\w\s]+(team|staff)/i, # others: Team, Team Bios
    'missionlinks' => /[\w\s]*mission\z/i, # others: Mission and Values
    'policylinks' => /[\w\s]*polic[\w]*\z/i, # others: Our values
    'contactlinks' => /\Acontact[\w\s]*\z/i,
    'adlinks' => /\Aadvertis/i, # others: Ads
    'contributelinks' => /^(contribut|support)/i, # others:  Ways to give
    'sponsorlinks' => /sponsor/i,
    DONATE => /\Adonat/i,
    'statesnewsroom' => /states[\s]?newsroom/i # Common fiscal host
  }

  # @return text content of first node.css(selector) found; nil if none
  def get_first_css(node, selector)
    nodelist = node.css(selector)
    return nodelist[0].content.strip.gsub(/[\t\n]/, '') if nodelist[0]
  end

  # @return hash of data from Yoast SEO when available; nil otherwise
  def get_yoast_graph(head)
    node = head.at_css('.yoast-schema-graph')
    return nil unless node
    begin
      yoast = JSON.parse(node.content)
    rescue StandardError => e
      yoast['error_get_yoast_graph'] = "#{e.message}\n\n#{e.backtrace.join("\n\t")}"
    end
    return yoast
  end

  # @return hash of various head > meta fields of interest
  def get_metas(head)
    metas = {}
    nodelist = head.xpath('title')
    metas['title'] = nodelist[0].content if nodelist[0]
    nodelist = head.xpath('meta[@property="og:title"]')
    metas['titleog'] = nodelist[0]['content'] if nodelist[0]
    nodelist = head.xpath('meta[@property="og:description"]')
    metas['descriptionog'] = nodelist[0]['content'] if nodelist[0]
    nodelist = head.xpath('meta[@name="description"]')
    metas['description'] = nodelist[0]['content'] if nodelist[0]
    nodelist = head.xpath('meta[@name="twitter:site"]')
    metas['twitter'] = nodelist[0]['content'] if nodelist[0]
    nodelist = head.xpath('meta[@name="generator"]')
    metas['generator'] = []
    nodelist.each do | n |
      metas['generator'] << n['content']
    end
    nodelist = head.xpath('link[@rel="canonical"]')
    metas['canonical'] = nodelist[0]['href'] if nodelist[0]
    nodelist = head.xpath('link[@rel="icon"][@sizes="32x32"]')
    metas['icon32'] = nodelist[0]['href'] if nodelist[0]
    metas['yoast'] = get_yoast_graph(head)
    return metas
  end

  # @return absolute url, or nil if non-useful (i.e. just a # fragment or blank href)
  def absolute_href(base, href)
    return nil if href.nil?
    return nil if /\/?#\z/.match(href) # Skip bare fragments
    url = URI(href)
    return url.absolute? ? url.to_s : URI(base).merge(href).to_s
  end

  # @return hash of interesting unique hrefs
  def get_links(siteurl, nodelist, lookfor)
    tmp = Hash.new { | h, k | h[k] = [] }
    nodelist.each do | node | # FIXME horribly inefficient
      txt = node.content
      lookfor.each do | id, regex |
        if regex.match(txt)
          abshref = absolute_href(siteurl, node['href'])
          tmp[id] << abshref if abshref
        end
      end
    end
    links = {}
    tmp.each do | k, v | # TODO find better way to ensure uniqueness
      links[k] = v.to_a.uniq
    end
    return links
  end

  # @return hash of interesting unique hrefs, plus all links text separately
  def get_links_all(siteurl, nodelist, lookfor)
    links = get_links(siteurl, nodelist, lookfor)
    links[ALLLINKS] = []
    nodelist.map(&:content).uniq.each do | txt |
      if txt
        t = txt.strip.gsub(NORMALIZE_PAT, NORMALIZE_MAP)
        links[ALLLINKS] << t if t.length > 3 # Arbitrary; ignore non-word links
      end
    end
    return links
  end

  # @return hash of arrays of text nodes matching our maps
  def scan_text(nodelist, lookfor)
    texts = {}
    lookfor.each do | id, regex |
      texts[id] = nodelist.map(&:content).select { | t | regex.match(t) }
    end
    return texts
  end

  # @return hash of various potentially useful data
  def parse_newsurl(io, siteurl)
    data = Hash.new{ |h,k| h[k] = [] }
    begin
      doc = Nokogiri::HTML5(io)
      body = doc.xpath('/html/body')
      CSS_MAP.each do | id, selector|
        data[id] = get_first_css(body, selector)
      end
      data[METAS] = get_metas(doc.xpath('/html/head'))
      data[LINKS] = get_links(siteurl, doc.css('a'), LINKRX_MAP)
      data[NAVLINKS] = get_links_all(siteurl, doc.css('nav a'), LINKRX_MAP)
      data[FOOTERLINKS] = get_links_all(siteurl, doc.css('footer a'), LINKRX_MAP)
      data[TEXT_MATCHES] = scan_text(doc.xpath('/html/body//text()'), TEXTRX_MAP)
      if HACK_DO_ABOUT ### HACK excess network reads
        if data[TEXT_MATCHES][EIN_SCAN].empty?
          # If we didn't find any EINs, then also parse about pages to scan text
          abouts = data[LINKS][ABOUT]
          if abouts
            abouts.each do | u |
              next if u.nil?
              next if u.start_with?('#') # Don't bother parsing links that are just fragments
              url = URI(u)
              if !url.absolute?
                url = URI(siteurl).merge(u).to_s
              end
              # Read the about url (no caching) and do partial scan
              MODULE_LOG << "Parsing about link: #{url}"
              aio = URI.open(url).read
              adoc = Nokogiri::HTML(aio)
              data[TEXT_MATCHES][url] = scan_text(adoc.xpath('/html/body//text()'), TEXTRX_MAP)
            end
          end
          donates = data[LINKS][DONATE]
          if donates
            donates.each do | u |
              next if u.nil?
              next if u.start_with?('#') # Don't bother parsing links that are just fragments
              url = URI(u)
              if !url.absolute?
                url = URI(siteurl).merge(u).to_s
              end
              # Read the about url (no caching) and do partial scan
              MODULE_LOG << "Parsing donate link: #{url}"
              aio = URI.open(url).read
              adoc = Nokogiri::HTML(aio)
              data[TEXT_MATCHES][url] = scan_text(adoc.xpath('/html/body//text()'), TEXTRX_MAP)
            end
          end
        end
      end ### HACK_DO_ABOUT

      itemtypes = body.xpath('//*[@itemtype]') # Does the site use schema.org metadata?
      data['itemtypes'] = itemtypes.children.length unless itemtypes.children.empty?
    rescue StandardError => e
      MODULE_LOG << "error_parse_newsurl(#{siteurl}): #{e.message}"
      data['error_parse_newsurl'] = "#{e.message}\n\n#{e.backtrace.join("\n\t")}"
    end
    return data
  end

  # @return normalized name for cached file from url
  def url2file(url)
    return URI(url.downcase).host.sub('www.','').gsub('.', '_')
  end

  # Get the plain html of a news website, aggressively caching in CACHE_SUBDIR
  # @param url as string of site to grab
  # @param dir as local directory for cache
  # @param filename as local file to cache
  # @param refresh if true, force a lookup from site
  # @return filepath/name of the site's .html content, bare
  def get_site(url, dir, file, refresh = false)
    cache_dir = File.join(dir, CACHE_SUBDIR)
    Dir.mkdir(cache_dir) unless Dir.exist?(cache_dir)
    filename = File.join(cache_dir, file)
    begin
      if refresh or !File.exist?(filename)
        File.open(filename, 'w') do |f|
          f.puts URI.open(url).read
        end
      end
      return File.open(filename)
    rescue StandardError => e
      MODULE_LOG << "error_get_site: #{e.message}\n\n#{e.backtrace.join("\n\t")}"
      return nil
    end
  end

  # Convenience method to scrape one site and dump all data to .json
  def process_site(siteurl, dir, org)
    filename = url2file(siteurl)
    io = get_site(siteurl, dir, "#{filename}.html", false)
    data = parse_newsurl(io, siteurl)
    # If we are given manual data about the org, pass it through
    if org
      org.each do | k, v |
        data[k] = v # REVIEW This may overwrite some scanned data
      end
    end
    File.open(File.join(dir, "#{filename}.json"), 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
  end

  # Convenience method to condense some site data and aggregate data across sites
  def condense_site(fileroot, aggregate)
    begin
      data = JSON.load_file("#{fileroot}.json")
      condensed = {}
      identifier = File.basename(fileroot)
      aggregate['sites'] << identifier
      # Gather some metadata first when present
      socials = {}
      socials['twitter'] = data[METAS].fetch('twitter', nil)
      orgname = nil
      yoast = data[METAS].fetch('yoast', nil)
      if yoast
        yoast['@graph'].each do | elem |
          next unless 'Organization'.eql?(elem.fetch('@type', nil))
          orgname = elem['name']
          sameas = elem.fetch('sameAs', nil)
          if sameas
            SOCIAL_MAP.each do | id, regex |
              found = sameas.select{ |s| regex.match(s)}.first
              socials[id] = found if found
            end
          end
        end
      end
      condensed['identifier'] = identifier
      condensed['identifier_hack'] = data.fetch('identifier', '')
      condensed['title'] = data[METAS].fetch('title', nil)
      condensed['title'] = data[METAS].fetch('titleog', '') unless condensed['title']
      condensed['commonName'] = data.fetch('commonName', '')
      condensed['legalName'] = orgname
      condensed['legalName_hack'] = data.fetch('legalName', '')
      condensed['description'] = data[METAS].fetch('description', nil)
      condensed['description'] = data[METAS].fetch('descriptionog', '') unless condensed['description']
      condensed['website'] = data[METAS].fetch('canonical', nil)
      condensed['website'] = data.fetch('website', '') unless condensed['website']
      condensed['slogan'] = data.fetch('slogan', '')
      condensed['copyright'] = data['copyright'] if data.has_key?('copyright')
      condensed['imprint'] = data['imprint'] if data.has_key?('imprint')
      condensed['masthead'] = nil
      condensed['location'] = data.fetch('location', '')
      condensed['state'] = data.fetch('state', '')
      condensed['boardSize'] = nil
      condensed['boardType'] = nil
      condensed['membershipType'] = nil
      condensed['boardurl'] = data[LINKS].fetch('boardlinks', nil)
      condensed['bylawsurl'] = nil
      condensed['policyurl'] = data[LINKS].fetch('policylinks', nil)
      condensed['teamurl'] = data[LINKS].fetch('teamlinks', nil)
      condensed['missionurl'] = data[LINKS].fetch('missionlinks', nil)
      condensed['numberOfEmployees'] = nil
      condensed['taxID'] = data.fetch('taxID', nil)
      condensed['taxIDLocal'] = nil
      condensed['nonprofitStatus'] = nil
      condensed['budgeturl'] = nil
      condensed['budgetUsd'] = nil
      condensed['budgetYear'] = nil
      condensed['donateurl'] = data[LINKS].fetch('donatelinks', nil)
      condensed['contributeurl'] = data[LINKS].fetch('contributelinks', nil)
      condensed['sponsorurl'] = data[LINKS].fetch('sponsorlinks', nil)
      condensed['advertising'] = data[LINKS].fetch('adlinks', nil)
      condensed['telephone'] = nil
      condensed['contactUs'] = data[LINKS].fetch('contactlinks', nil)
      condensed['icon32'] = data[METAS]['icon32']
      generator = data[METAS].fetch('generator', [])
      condensed['webgenerator'] = generator.to_s unless generator.empty?
      condensed[SOCIALLINKS] = socials
      eins = []
      nonprofit = []
      data['textmatch'].each do | k, v | # HACK need to figure out what we really need here
        tmp = {}
        next if 'nonprofit'.eql?(k)
        if '501c3'.eql?(k)
          nonprofit.concat(v)
        else
          if EIN_SCAN.eql?(k)
            tmp = v
          else
            tmp = v[EIN_SCAN]
          end
          eins.concat(tmp) unless tmp.empty?
          end
      end
      condensed[EIN_SCAN] = eins
      condensed['nonprofit'] = nonprofit
      MODULE_LOG << "condense_site(#{fileroot}): found possible EIN(s)" unless eins.empty?

      File.open("#{fileroot}.md", 'w') do |f|
        f.puts condensed.to_yaml()
      end
      if data[NAVLINKS].has_key?(ALLLINKS)
        data[NAVLINKS][ALLLINKS].each do | l |
          aggregate[NAVLINKS][l] += 1
        end
      end
      if data[FOOTERLINKS].has_key?(ALLLINKS)
        data[FOOTERLINKS][ALLLINKS].each do | l |
          aggregate[FOOTERLINKS][l] += 1
        end
      end
    rescue StandardError => e
      MODULE_LOG << "condense_site(#{fileroot}): #{e.message}\n\n#{e.backtrace.join("\n\t")}"
    end
  end

  # ### #### ##### ######
  # Main methods for command line use
  def process_csv(dir, orgarray)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    orgarray.each do | orghash |
      process_site(orghash['website'], dir, orghash)
    end
  end
  def process_condense(dir, outfile)
    data = {} # Aggregate lists of common link names
    data[NAVLINKS] = Hash.new(0)
    data[FOOTERLINKS] = Hash.new(0)
    data['sites'] = []
    Dir["#{dir}/*.json"].each do |f|
      condense_site(f.sub('.json', ''), data)
    end
    data[NAVLINKS] = data[NAVLINKS].reject { |k,v| v < 2 }
    data[FOOTERLINKS] = data[FOOTERLINKS].reject { |k,v| v < 2 }
    data[NAVLINKS] = Hash[data[NAVLINKS].sort_by { |k, v| -v }]
    data[FOOTERLINKS] = Hash[data[FOOTERLINKS].sort_by { |k, v| -v }]
    data['npdetectorlog'] = MODULE_LOG
    File.open(outfile, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
  end

  if __FILE__ == $PROGRAM_NAME
    dir = '../../anpdetector'
    infile = 'npdetector.csv'
    outfile = 'npdetector.json'
    csv = CSV.new(File.read(infile), :headers => true).to_a.map {|row| row.to_hash }
    process_csv(dir, csv)
    process_condense(dir, outfile)
    puts "#{self.name} done, see: #{outfile}"
  end
end
