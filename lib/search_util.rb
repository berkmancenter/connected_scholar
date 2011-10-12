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
    parse_gs_a(gs_r)
  end

  def build_google_links(gs_r, title)
    ((a = (gs_r/"div.gs_rt > h3 > a")) && a.first) ? [[title, a.first[:href]]] : []
  end

  def parse_cite(gs_r)
    yield((gs_r/"span.gs_a").inner_text)
  end

  def parse_gs_a(gs_r)
    parse_cite(gs_r) do |cite|
      parse_creator(cite) do |creator, x|
        parse_publisher(x) do |publisher, y|
          parse_year(y) do |year, z|
            parse_link_title(z) do |link_title|
              parse_desc(gs_r, cite) do |desc|
                parse_title(gs_r) do |title|
                  return {
                      "title" => title,
                      "creator" => [creator],
                      "desc_subject" => desc,
                      "pub_date" => year,
                      "publisher" => publisher,
                      "links" => build_google_links(gs_r, link_title)
                  }
                end
              end
            end
          end
        end
      end
    end
  end

  def parse_title(gs_r)
    yield((gs_r/"div.gs_rt").inner_text.
        gsub('[PDF] ', '').
        gsub('[BOOK] ', '').
        gsub('[CITATION] ', ''))
  end

  def parse_desc(gs_r, cite)
    yield (gs_r/"font").inner_text.gsub(cite, "").strip
  end

  def parse_creator(cite)
    first_dash = cite.index('-')
    if first_dash
      yield cite[0..first_dash-1].strip, cite[first_dash+1..-1].strip
    else
      yield cite.strip, ""
    end
  end

  def parse_year(gs_r_tail)
    first_dash = gs_r_tail.index('-')
    if first_dash
      year = gs_r_tail[0..first_dash-1].strip
      yield((year.scan(/19\d\d|20\d\d/)[0]), gs_r_tail[first_dash+1..-1].strip)
    else
      yield gs_r_tail.strip, ""
    end
  end

  def parse_publisher(gs_r_tail)
    first_dash = gs_r_tail.index('-')
    if first_dash
      pub_and_year = gs_r_tail[0..first_dash-1].strip
      yield pub_and_year.gsub(/(, )?(19\d\d|20\d\d)$/, ''), gs_r_tail.strip
    else
      yield gs_r_tail.strip, ""
    end
  end

  def parse_link_title(gs_r_tail)
    yield gs_r_tail.empty? ? nil : gs_r_tail.strip
  end
end