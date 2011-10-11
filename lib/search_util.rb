module SearchUtil

  def item_search(search_type, query, limit=25, start=0, sort=nil, filters=[])
    with_librarycloud do |key, url|
      search_url = "#{url}/api/item/?key=#{key}&search_type=#{search_type}&query=#{CGI::escape(query)}&limit=#{limit}&start=#{start}"
      unless sort.nil? or sort == ""
        search_url += "&sort=#{sort}%20desc"
      end
      filters.each do |f|
        search_url += "&filter=#{f[:filter_type]}:#{CGI::escape(f[:filter])}"
      end
      Rails.logger.info "LC => #{search_url}"
      items = JsonUtil::get_json search_url
      Rails.logger.info "LibraryCloud service returned a response"
      return items.merge(
          "docs" => items['docs'].map { |item|
            item.merge('links' => (item['id_inst'] && item['id_inst'] != "") ?
                [["Hollis", item_link(item['id_inst'])]] : [])
          }
      )
    end
  rescue RestClient::RequestTimeout => e
    return {
        "errors" => e.message
    }
  end

  def item_link(hollis_id)
    with_hollis do |url, item_prefix|
      "#{url}#{item_prefix}#{hollis_id}"
    end
  end

  def google_search(query, limit, start)
    with_google do |url|
      search_url = "#{url}?q=#{CGI::escape(query)}&num=#{limit}&start=#{start}"
      JsonUtil::get_html(search_url) do |html|
        # remove uni-code chars
        doc = Hpricot(html.gsub!(/[\x80-\xff]/, ""))
        return {
            "docs" => (doc/"div.gs_r").map { |gs_r| parse_google_record(gs_r) },
            "limit" => limit,
            "start" => start,
            "num_found" => -1,
            "sortable" => false
        }
      end
    end
  rescue ArgumentError => e
    puts e.backtrace.join("\n")
  end

  private

  def with_librarycloud
    yaml = YAML.load_file("#{Rails.root}/config/librarycloud.yml")
    yield yaml['key'], yaml['url']
  end

  def with_hollis
    yaml = YAML.load_file("#{Rails.root}/config/hollis.yml")
    yield yaml['url'], yaml['item_prefix']
  end

  def with_google
    yaml = YAML.load_file("#{Rails.root}/config/googlescholar.yml")
    yield yaml['url']
  end

  def parse_google_record(gs_r)
    {
        "title" => build_google_title(gs_r),
        "creator" => build_google_creator(gs_r),
        "desc_subject" => (gs_r/"font").inner_text,
        "links" => build_google_links(gs_r)
    }
  end

  def build_google_title(gs_r)
    (gs_r/"div.gs_rt").inner_text.
        gsub('[PDF] ', '').
        gsub('[BOOK] ', '').
        gsub('[CITATION] ', '')
  end

  def build_google_creator(gs_r)
    [(gs_r/"span.gs_a").inner_text.split('-').first]
  end

  def build_google_links(gs_r)
    ((a = (gs_r/"div.gs_rt > h3 > a")) && a.first) ? [["Google", a.first[:href]]] : []
  end
end