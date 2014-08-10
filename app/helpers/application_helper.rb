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

  def stopover_text nb_stops
    html = ""
    case nb_stops
      when 0
        html = "Vol direct"
      when 1
        html = "1 escale"
      when 2
        html = "2+ escales"
    end

    html
  end

end
