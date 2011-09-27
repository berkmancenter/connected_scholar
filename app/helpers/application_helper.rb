module ApplicationHelper
  include EtherpadUtil

  def flash_helper
    f_names = [:notice, :warning, :message, :alert]

    f_names.inject("") do |html, name|
      flash[name].nil? ? html : "#{html}<div class=\"flash #{name}\">#{flash[name]}</div>"
    end
  end

  def display_datetime(datetime, span_id=UUID.generate)
    # really should do this in the client timezone.  which means it would need to be done in JS
    if datetime.to_date == Date.today
      format = "'at' h:MM TT"
    else
      format = "'on' mmm d, yyyy"
    end
    format_datetime(datetime, format, span_id)
  end

  def format_datetime(datetime, format, span_id=UUID.generate)
    <<HTML
#{set_element_datetime(datetime, format, span_id)}
<span id="#{span_id}"></span>
HTML
  end

  def set_element_datetime(datetime, format, elem_id)
    if datetime
    <<HTML
<script>
    jQuery(document).ready(function() {
      $("##{elem_id}").append(((new Date(Date.UTC(
          #{datetime.year},
          #{datetime.month - 1},
          #{datetime.day},
          #{datetime.hour},
          #{datetime.min}
      ))).format("#{format}")))
    });
</script>
HTML
    else
      ""
    end
  end
end
