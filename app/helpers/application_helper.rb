module ApplicationHelper
  def minutes_to_hm(minutes)
    return "—" if minutes.nil?

    hours = minutes / 60
    mins  = minutes % 60

    "#{hours}h #{mins.to_s.rjust(2, '0')}m"
  end

  def greeting_by_time
    hour = Time.current.hour

    if hour < 12
      I18n.t("dashboard.greeting_morning")
    elsif hour < 18
      I18n.t("dashboard.greeting_afternoon")
    else
      I18n.t("dashboard.greeting_evening")
    end
  end

  def format_date_bilingual(date)
    if I18n.locale == :ja
      date.strftime("%-m月%-d日（#{%w[日 月 火 水 木 金 土][date.wday]}）")
    else
      date.strftime("%A, %B %-d, %Y")
    end
  end

  def heatmap_color(minutes)
    case minutes
    when nil, 0
      "#EBEDF0"
    when 1..239
      "#C6E48B"
    when 240..419
      "#40C463"
    when 420..480
      "#30A14E"
    else
      "#FF6B6B"
    end
  end
end