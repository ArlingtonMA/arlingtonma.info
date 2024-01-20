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
  require 'set'

  MODULE_LOG = [] # Simplistic logging if needed
  ### Other parsing ideas
  # link rel="alternate" type="application/rss+xml" multiple URLS to feeds
  # link rel="https://api.w.org/" signals Wordpress hosting?
  # link rel="amphtml" provides AMP pages for Google?
  # Wordpress theme name: links like: (MIT) ${url}/wp-content/themes/[a-zA-z-]*/style.css
  # Many sites use yoast: <script type="application/ld+json" class="yoast-schema-graph">...
  TEST_SITES_X = %w[ https://FigCityNews.com/ ]
  TEST_SITES_Y = %w[ https://ctmirror.org/  https://FigCityNews.com/ https://hartfordtimes.com/ https://indepthnh.org/ https://nancyonnorwalk.com/ https://newhampshirebulletin.com/ https://newhavenindependent.org/ https://pinetreewatch.org/ https://pvdeye.org/ https://tewksburycarnation.org/ https://theconcordbridge.org/ https://thelocalnews.news/ https://vtdigger.org/ https://www.amjamboafrica.com/ https://www.charlottenewsvt.org/ https://www.commonsnews.org/ https://www.CTMirror.org/ https://www.ecoRI.org/ https://www.ipswichlocalnews.com/ https://www.lexobserver.org/ https://www.oceanstatestories.org/ https://www.themainemonitor.org/ https://www.waterburyroundabout.org/ https://www.yourarlington.com/]
  TEST_SITES = %w[
    https://avlwatchdog.org/
https://aspenjournalism.org
https://www.baltimorebrew.com
https://shastascout.org/
https://beltmag.com
https://austonia.com
https://carolinapublicpress.org
https://nowkalamazoo.com
https://chicosol.org
https://www.civicstory.org
https://www.coastalreview.org
https://codastory.com
https://dcist.com
https://eastlansinginfo.news
https://www.bayoubrief.com
https://www.floridabulldog.org
https://www.greensourcedfw.org
https://www.hcn.org
https://www.thedailycatch.org
https://marylandreporter.com
https://matternews.org
https://mountainjournal.org
https://www.midstory.org
https://minnpost.com
https://Mississippitoday.org
https://montanafreepress.org
https://www.mymcmedia.org
https://www.njspotlight.com
https://oklahomawatch.org
https://voiceofoc.org
https://www.Calo.org
https://www.searchlightnm.org
https://www.TucsonSentinel.com
https://missionlocal.org
https://www.sdnewswatch.org
https://tarbell.org
https://boulderreportinglab.org
https://theaustinbulldog.org
https://latinorebels.com
https://boyleheightsbeat.com
https://breckenridgetexan.com
https://thecity.nyc
https://www.thecurrentla.com
https://www.daggerpress.com
https://thedcline.org
https://thefern.org/donate
https://kycir.org
https://thelensnola.org
https://www.thelundreport.org/
https://investigatemidwest.org
https://thetylerloop.com
https://nkytribune.com
https://wisconsinwatch.org
https://nuvo.net
https://billypenn.com
https://chicagoreporter.com
https://therivardreport.com
https://rochesterbeacon.com
https://sammamish.news
https://sierranevadaally.org
https://southsideweekly.com
https://utahinvestigative.org
https://www.localnewsmatters.org
https://www.tonemadison.com
https://iowacapitaldispatch.com/
https://voicesofmontereybay.org
https://thenevadaindependent.com
https://www.spotlightpa.org
https://www.marylandmatters.org
https://witnessla.com
https://www.wyofile.com
https://www.inewsource.org
https://SanJoseInside.com
https://xtown.la
https://eltimpano.org
https://berkeleyside.com
https://coloradonewsline.com/
https://coloradofoic.org/
https://ljidelaware.org
https://jaxtoday.org
https://verocommunique.com
https://thecurrentga.org
https://austintalks.org/
https://hoptownchronicle.org/
https://eplocalnews.org
https://webbcity.net
https://thebeacon.media
https://thelocalreporter.press
https://NorthCarolinaHealthNews.org
https://nmindepth.com
https://chalkbeat.org
https://documentedny.com/about-us
https://www.nysfocus.com
https://www.austinmonitor.com
https://theaustinbulldog.org
https://www.virginiamercury.com
https://cardinalnews.org
https://www.gigharbornow.org
https://www.spokanefavs.com
https://www.wausaupilotandreview.com
https://www.mountainstatespotlight.org
https://mountainstatespotlight.org/
https://www.cinespeak.org/
https://azluminaria.org
https://grist.org
https://www.conectaarizona.com
https://www.catchlight.io
https://fresnoland.org
https://openvallejo.org
https://RiversideRecord.org
https://edsource.org
https://lookoutlocal.com
https://www.afrolanews.org
https://www.berkeleyside.com
https://spotlightschools.com
https://thefrisc.com
https://westsideobserver.com
https://theyappie.com
https://www.themarjorie.org
https://www.oviedocommunitynews.org
https://jaxtrib.org
https://www.theatlantavoice.com
https://canopyatlanta.org
https://macon-newsroom.com
https://www.objectivejournalism.org
https://www.therecordnorthshore.org
https://illinoisanswers.org
https://harveyworld.org
https://civiclex.org
https://thebaltimorebanner.com
https://cecil.tv
https://tostadamagazine.com
https://theuptake.org
https://join.theoptimist.mn
https://www.kansascitydefender.com
https://www.mississippifreepress.org
https://ashevillefreepress.com
https://nebraskajournalismtrust.org
https://jerseybee.org
https://www.montclairlocal.news
https://atlanticcityfocus.tinynewsco.org
https://bloomfieldinfo.org
https://www.publicsq.org
https://questanews.com
https://www.doublescoop.art
https://thedailycatch.org
https://nyc.streetsblog.org
https://www.TheBuckeyeFlame.com
https://eyeonohio.com
https://www.thelandcle.org
https://www.Blackgirlincle.com
https://www.thereportingproject.org
https://www.bigiftrue.org
https://ashland.news
https://www.underscore.news
https://www.tubecityonline.com
https://www.thegburgvoice.org
https://www.thegreencities.com
https://elpasomatters.org
https://www.islandmatters.org/
https://nowcastsa.com
https://www.texasobserver.org
https://www.austinvida.com
https://tumbleweird.org
  ]
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
    EIN_SCAN => /ein[\w\s]+(01|02|03|04|05|06|10|11|12|13|14|15|16|20|21|22|23|24|25|26|27|30|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|46|47|48|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|71|72|73|74|75|76|77|80|81|82|83|84|85|85|86|86|87|87|88|88|90|91|92|92|93|94|95|98|99|)[-]?\d{7}/i
  }
  METAS = 'metas'
  LINKS = 'links'
  NAVLINKS = 'linksnav'
  FOOTERLINKS = 'linksfooter'
  ALLLINKS = 'alllinks'
  ABOUT = 'aboutlinks'
  DONATE = 'donatelinks'
  LINKRX_MAP = {
    ABOUT => /\Aabout[-]?[u]?/i,
    'boardlinks' => /\Aboard/i,
    'teamlinks' => /\Ameet[\w\s]+team/i,
    'missionlinks' => /[\w\s]*mission\z/i,
    'policylinks' => /[\w\s]*polic[\w]*\z/i,
    'contactlinks' => /\Acontact[\w\s]*\z/i,
    'adlinks' => /\Aadvertis/i,
    'contributelinks' => /\Acontribut/i,
    DONATE => /\Adonat/i
  }

  # @return text content of first node.css(selector) found; nil if none
  def get_first_css(node, selector)
    nodelist = node.css(selector)
    return nodelist[0].content.strip.gsub(/[\t\n]/, '') if nodelist[0]
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
    return metas
  end

  # @return hash of various potentially interesting unique link hrefs
  def get_links(nodelist, lookfor)
    tmp = Hash.new { | h, k | h[k] = [] }
    nodelist.each do | node | # FIXME horribly inefficient
      txt = node.content
      lookfor.each do | id, regex |
        if regex.match(txt)
          tmp[id] << node['href']
        end
      end
    end
    links = {}
    tmp.each do | k, v | # TODO find better way to ensure uniqueness
      links[k] = v.to_a.uniq
    end
    return links
  end

  # @return hash of interesting link hrefs, plus all link contents
  def get_links_all(nodelist, lookfor)
    links = get_links(nodelist, lookfor)
    links[ALLLINKS] = []
    nodelist.map(&:content).uniq.each do | txt |
      if txt
        t = txt.strip
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
      data[LINKS] = get_links(doc.css('a'), LINKRX_MAP)
      data[NAVLINKS] = get_links_all(doc.css('nav a'), LINKRX_MAP)
      data[FOOTERLINKS] = get_links_all(doc.css('footer a'), LINKRX_MAP)
      data[TEXT_MATCHES] = scan_text(doc.xpath('/html/body//text()'), TEXTRX_MAP)
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

      itemtypes = body.xpath('//*[@itemtype]') # Does site use schema.org metadata?
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

  # Get the plain html of a news website, aggressively caching
  # @param url as string of site to grab
  # @param filename as local file to cache
  # @param refresh if true, force a lookup from site
  # @return filepath/name of the site's .html content, bare
  def get_site(url, filename, refresh = false)
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

  # Convenience method to scrape one site and dump all data
  def process_site(siteurl, dir)
    fileroot = File.join(dir, url2file(siteurl))
    io = get_site(siteurl, "#{fileroot}.html", false)
    data = parse_newsurl(io, siteurl)
    File.open("#{fileroot}.json", 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end
    condense_site(fileroot)
  end

  # Convenience method to condense site data and aggregate similar data
  def condense_site(fileroot, aggregate)
    begin
      data = JSON.load_file("#{fileroot}.json")
      condensed = {}
      condensed['title'] = data[METAS].fetch('title', nil)
      condensed['title'] = data[METAS].fetch('titleog', '') unless condensed['title']
      condensed['description'] = data[METAS].fetch('description', nil)
      condensed['description'] = data[METAS].fetch('descriptionog', '') unless condensed['description']
      condensed['generator'] = data[METAS].fetch('generator', []).to_s
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
      MODULE_LOG << "condense_site(#{fileroot}): found EIN" unless eins.empty?
      File.open("#{fileroot}.yml", 'w') do |f|
        f.puts condensed.to_yaml(:stringify_names => true)
      end
      aggregate[NAVLINKS].merge(data[NAVLINKS][ALLLINKS]) if data[NAVLINKS].fetch(ALLLINKS, nil)
      aggregate[FOOTERLINKS].merge(data[FOOTERLINKS][ALLLINKS]) if data[FOOTERLINKS].fetch(ALLLINKS, nil)

    rescue StandardError => e
      MODULE_LOG << "condense_site(#{fileroot}): #{e.message}\n\n#{e.backtrace.join("\n\t")}"
    end
  end

  # ### #### ##### ######
  # Main method for command line use
  def process_test(dir)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    TEST_SITES.each do | siteurl |
      process_site(siteurl, dir)
    end
  end
  def process_condense(dir)
    data = {} # Aggregate lists of common link names
    data[NAVLINKS] = Set.new()
    data[FOOTERLINKS] = Set.new()
    Dir["#{dir}/*.json"].each do |f|
      condense_site(f.sub('.json', ''), data)
    end
    data[NAVLINKS] = data[NAVLINKS].to_a.sort
    data[FOOTERLINKS] = data[FOOTERLINKS].to_a.sort
    File.open("npdetector.json", 'w') do |f|
        f.puts JSON.pretty_generate(data)
      end
  end
  if __FILE__ == $PROGRAM_NAME
    dir = 'tmp'
    # process_test(dir)
    # condense_site(...)
    process_condense(dir)
    puts "---- done; log of warnings:"
    puts JSON.pretty_generate(MODULE_LOG)
  end
end
