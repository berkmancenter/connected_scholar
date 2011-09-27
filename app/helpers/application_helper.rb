module ApplicationHelper
  include EtherpadUtil

  def flash_helper
    f_names = [:notice, :warning, :message, :alert]

    f_names.inject("") do |html, name|
      flash[name].nil? ? html : "#{html}<div class=\"flash #{name}\">#{flash[name]}</div>"
    end
  end

  def display_datetime(datetime, span_id)
    # really should do this in the client timezone.  which means it would need to be done in JS
    if datetime.to_date == Date.today
      format = "h:MM TT"
    else
      format = "h:MM TT 'on' mmm d, yyyy"
    end
    <<HTML
<script>
    jQuery(document).ready(function() {
      $("##{span_id}").append(((new Date(Date.UTC(
          #{datetime.year},
          #{datetime.month},
          #{datetime.day},
          #{datetime.hour},
          #{datetime.min}
      ))).format("#{format}")))
    });
</script>
<span id="#{span_id}"></span>
HTML
  end
end
