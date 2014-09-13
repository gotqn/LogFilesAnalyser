class ReportsController < ApplicationController

  authorize_resource class: false

  # GET /log_files
  # GET /log_files.json
  def index
    @search = LogFile.search(params[:q])
    @log_files = @search.result(distinct: false).includes(:search_statistic).page(params[:page]).per(5)
  end

end
