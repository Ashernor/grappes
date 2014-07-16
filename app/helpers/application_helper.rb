module ApplicationHelper

  def long_date_with_html date
    html = ""
    html += I18n.l date, format: "%A"
    html += "<span>"
    html += I18n.l date, format: " %d %B"
    html += "</span>"
    html += I18n.l date, format: " %Y"

    raw(html)
  end
end
