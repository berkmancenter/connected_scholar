module ApplicationHelper
  include EtherpadUtil

  def flash_helper
    f_names = [:notice, :warning, :message, :alert]

    f_names.inject("") do |html, name|
      flash[name].nil? ? html : "#{html}<div class=\"flash #{name}\">#{flash[name]}</div>"
    end
  end
end
