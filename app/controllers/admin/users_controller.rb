module Admin
  class UsersController < ApplicationController
    before_action :require_admin!

    def index
      redirect_to admin_dashboard_path
    end

    def show
      @user = User.find(params[:id])
      @work_logs = @user.work_logs
                        .order(clocked_in_at: :desc)
                        .page(params[:page]).per(20)
    end

    def export
      @user = User.find(params[:id])
      @work_logs = @user.work_logs.completed.order(clocked_in_at: :asc)
      
      safe_name = @user.name.to_s.strip.gsub(/[^a-zA-Z0-9]/, "_")
      
      respond_to do |format|
        format.csv do
          filename  = "kintai_#{@user.role}_#{safe_name}_all.csv"
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
          pdf.text "Attendance History", style: :bold
          pdf.font_size 12
          pdf.text "Records: #{@work_logs.count}", color: "6B6860"
          pdf.move_down 20
          
          pdf.text "Name: #{@user.name}", style: :bold
          pdf.text "Email: #{@user.email}"
          pdf.move_down 20
          
          if @work_logs.empty?
            pdf.text "No records found.", align: :center, color: "6B6860"
          else
            table_data = [
              ["Date", "Clock In", "Clock Out", "Duration", "Memo", "Overtime"]
            ]
            
            @work_logs.each do |log|
              date_str = "#{log.clocked_in_at.strftime('%Y-%m-%d')} #{log.clocked_in_at.strftime('%a')}"
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
          
          filename = "kintai_#{@user.role}_#{safe_name}_all.pdf"
          send_data pdf.render, filename: filename, type: "application/pdf", disposition: "attachment"
        end
      end
    end

    private

    def require_admin!
      unless current_user&.role == 'admin'
        redirect_to root_path, alert: t('admin.access_denied')
      end
    end
  end
end