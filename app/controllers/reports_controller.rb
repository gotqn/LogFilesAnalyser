class ReportsController < ApplicationController

  authorize_resource class: false

  # GET /log_files
  # GET /log_files.json
  def index
    @search = LogFile.search(params[:q])
    @log_files = @search.result(distinct: true).page(params[:page]).per(1).includes(:runtime_statistics)
  end

end


#
#def index
#  @q = Household.search(params[:q])
##  @households = @q.result.page(params[:page]).per(5)
#end