module ApplicationHelper
  def minutes_to_hm(minutes)
    return "—" if minutes.nil? || minutes.zero?

    hours = minutes / 60
    mins  = minutes % 60

    "#{hours}h #{mins.to_s.rjust(2, '0')}m"
  end

  def greeting_by_time
    hour = Time.current.hour

    if hour < 12
      "Good morning"
    elsif hour < 18
      "Good afternoon"
    else
      "Good evening"
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