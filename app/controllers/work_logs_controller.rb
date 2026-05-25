class WorkLogsController < ApplicationController
  def index
    @month = if params[:month].present?
      Date.parse("#{params[:month]}-01")
    else
      Date.current.beginning_of_month
    end

    # Last 12 months for the dropdown (current month first)
    @month_options = 12.times.map { |i| Date.current.beginning_of_month - i.months }

    @work_logs =
      current_user.work_logs
                  .for_month(@month.year, @month.month)
                  .order(clocked_in_at: :desc)
                  .page(params[:page])
                  .per(20)
  end

  def export
    month = if params[:month].present?
      Date.parse("#{params[:month]}-01")
    else
      Date.current.beginning_of_month
    end

    @work_logs =
      current_user.work_logs
                  .for_month(month.year, month.month)
                  .completed
                  .order(clocked_in_at: :asc)

    safe_name = current_user.name.to_s.strip.gsub(/[^a-zA-Z0-9]/, "_")
    
    respond_to do |format|
      format.csv do
        filename  = "kintai_#{safe_name}_#{month.strftime('%Y-%m')}.csv"
        response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
        render template: "work_logs/export_csv"
      end
      format.pdf do
        pdf = Prawn::Document.new
        
        pdf.font_families.update("NotoSansJP" => {
          normal: Rails.root.join("vendor/fonts/NotoSansJP-Regular.ttf").to_s,
          bold: Rails.root.join("vendor/fonts/NotoSansJP-Regular.ttf").to_s
        })
        pdf.font "NotoSansJP"
        
        pdf.font_size 24
        pdf.text I18n.t('work_logs.title'), style: :bold
        pdf.font_size 12
        pdf.text I18n.t('work_logs.records', count: @work_logs.count), color: "6B6860"
        pdf.move_down 20
        
        pdf.text "Name: #{current_user.name}", style: :bold
        pdf.text "Email: #{current_user.email}"
        pdf.text "Month: #{month.strftime('%B %Y')}"
        pdf.move_down 20
        
        if @work_logs.empty?
          pdf.text I18n.t('work_logs.no_logs'), align: :center, color: "6B6860"
        else
          table_data = [
            ["Date", "Clock In", "Clock Out", "Duration", "Memo", "Overtime"]
          ]
          
          @work_logs.each do |log|
            date_str = "#{log.clocked_in_at.strftime('%-d')} #{log.clocked_in_at.strftime('%a')}"
            in_str = log.clocked_in_at.strftime('%H:%M')
            out_str = log.clocked_out_at ? log.clocked_out_at.strftime('%H:%M') : "—"
            dur_str = log.duration_minutes ? "#{log.duration_minutes / 60}h #{log.duration_minutes % 60}m" : "—"
            memo_str = log.memo.to_s
            ot_str = log.is_overtime ? "OT" : ""
            
            table_data << [date_str, in_str, out_str, dur_str, memo_str, ot_str]
          end
          
          pdf.table(table_data, header: true, width: pdf.bounds.width) do
            row(0).font_style = :bold
            row(0).background_color = "F7F6F3"
          end
        end
        
        filename = "kintai_#{safe_name}_#{month.strftime('%Y-%m')}.pdf"
        send_data pdf.render, filename: filename, type: "application/pdf", disposition: "attachment"
      end
    end
  end
end