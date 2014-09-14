class ReportsController < ApplicationController

  authorize_resource class: false

  # GET /log_files
  # GET /log_files.json
  def index
    @search = LogFile.search(params[:q])
    @log_files = @search.result(distinct: false).includes(:search_statistic).page(params[:page]).per(5)
  end

  # GET /log_files/1
  # GET /log_files/1.json
  def show

    @log_file_name = LogFile.find(params[:log_file_id]).name

    case params[:chart_type]
      when 'report_01'
        event_type_id = LogEventType.find_by_event_type('overall').id
        @log_events = LogEvent.select("EXTRACT(EPOCH FROM current_timestamp + (5 * row_number) * interval '1 second') as created_at, substring(event,6,position(' ' in event) - 7) as event")
                              .where(log_events: { log_event_type_id: event_type_id }, log_file_id: params[:log_file_id])
                              .order(:created_at)

      else #'report_02'

        event_type_id = LogEventType.find_by_event_type('temp').id
        if params[:data] == 'fan'
          @log_events = LogEvent.select("EXTRACT(EPOCH FROM current_timestamp + (row_number) * interval '1 second') as created_at, substring(event,12,position('%' in event) -12) as event")
                                .where(log_events: { log_event_type_id: event_type_id }, log_file_id: params[:log_file_id])
                                .order(:created_at)
        else
          @log_events = LogEvent.select("EXTRACT(EPOCH FROM current_timestamp + (row_number) * interval '1 second') as created_at, substring(event,0,position(' ' in event)) as event")
                                .where(log_events: { log_event_type_id: event_type_id }, log_file_id: params[:log_file_id])
                                .order(:created_at)
        end

    end

    respond_to do |format|
        format.json { render partial: 'reports/partials/render_chart_data.json.erb', data: @log_events, name: @log_file_name }
    end



  end


end
