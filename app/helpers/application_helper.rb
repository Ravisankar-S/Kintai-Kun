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
    # Palette matched to Stitch design reference (warm sage greens on cream bg)
    case minutes
    when nil, 0
      "#E8E4DD"   # warm empty – blends with cream bg
    when 1..239
      "#B8D4B0"   # light sage – short day
    when 240..419
      "#6AAF82"   # mid sage – half day+
    when 420..480
      "#3D8F5F"   # deep sage – full day
    else
      "#C0392B"   # warm red – overtime
    end
  end

  def avatar_for(user, size: 40, class_name: "")
    size = size.to_i
    classes = ["rounded-full", "object-cover", "bg-slate-100", class_name].compact.join(" ")
    size_style = "width: #{size}px; height: #{size}px;"

    if user.avatar.attached?
      image_tag(
        user.avatar,
        class: classes,
        alt: user.name,
        style: size_style,
        loading: "lazy"
      )
    else
      initials = user.name.to_s.strip.split(/\s+/).map { |part| part[0] }.join.first(2).to_s.upcase

      content_tag(
        :div,
        initials.presence || "?",
        class: [
          "flex items-center justify-center rounded-full",
          "bg-slate-100 text-slate-500 font-semibold",
          class_name
        ].compact.join(" "),
        style: size_style
      )
    end
  end
end