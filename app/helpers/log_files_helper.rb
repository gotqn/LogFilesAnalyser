module LogFilesHelper

  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue Exception => e
      return false
    end
  end

  def get_index_view_runtime_stats(stats)

    formatted_stats = Hash.new

    stats.each do |record|

      case record['stats']
        when /Started at/
          formatted_stats[:start_date] = record['stats'].sub(']','').sub('[',': ')
        when /Runtime/
          formatted_stats[:runtime] = record['stats']
        when /Average hashrate/
          formatted_stats[:hash] = record['stats'][record['stats'].index(': ') +2, 32]
        when /Accepted shares/
          formatted_stats[:accepted] = record['stats'][record['stats'].index(': ') +2, 32]
        when /Rejected shares/
          formatted_stats[:rejected] = record['stats'][record['stats'].index(': ') +2, 32]
        else
          next
      end

    end

    formatted_stats
  end

end
