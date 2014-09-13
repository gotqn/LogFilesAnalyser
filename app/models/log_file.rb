require 'fileutils'

class LogFile < ActiveRecord::Base

  # Uploader
  mount_uploader :log_file, LogFileUploader

  # Relationships
  has_one :access_type
  has_one :config_file, dependent: :destroy
  has_one :platform, dependent: :destroy
  has_many :gpus, dependent: :destroy
  has_many :runtime_statistics, dependent: :destroy
  has_many :pools, dependent: :destroy
  has_one :graphics_processing_unit, dependent: :destroy
  has_many :log_events, dependent: :delete_all
  has_one :search_statistic
  belongs_to :user

  # Update relationships models
  accepts_nested_attributes_for :config_file, allow_destroy: true

  # Validations
  validates :name, presence: true, length: { in: 8..32 }, uniqueness: true
  validates :description, presence: true, length: { in: 16..128 }
  validates :access_type_id, presence: true

  validates_presence_of :log_file
  validates_integrity_of :log_file
  validates_processing_of :log_file

  # Methods

    # helper methods

      def get_access_type_name
        AccessType.find(access_type_id).name
      end

      def get_config_file
        ConfigFile.find_by_log_file_id(id).json
      end

      def get_access_type_id_or_default
        access_type_id || AccessType.find_by_name('public').id
      end

      def get_access_type_description
        current_id = access_type_id || AccessType.find_by_name('public').id
        AccessType.find(current_id).description
      end

      def get_file_size
        (File.size(Rails.root.join('public').to_s + log_file.to_s).to_f / 2**20).round(2)
      end

      def get_platform_details
        LogFile.includes(:platform).where(id: id).first.platform
      end

      def get_gpu_details
        LogFile.includes(:gpus).where(id: id).first.gpus
      end

      def get_runtime_statistics
        LogFile.includes(:runtime_statistics).where(id: id).first.runtime_statistics
      end

      def get_pool_statistics
        Pool.includes(:pool_statistics).where(log_file_id: id)
      end

      def get_device_statistics
        GraphicsProcessingUnit.includes(:graphics_processing_unit_stat).where(log_file_id: id).order(:name)
      end

      def convert_time_to_minutes(time)
        time_parts = time.split(':')
        time_parts[0].to_i * 60 + time_parts[1].to_i
      end

    # processing methods

      def process_uploaded_file
        clear_unnecessary_lines
        extracting_platform_details
        extracting_gpus_details
        get_runtime_and_search_stats
        extracting_pool_statistics
        extracting_gpu_stats
        extracting_events
      end

      def clear_unnecessary_lines

        old_file_path = Rails.root.join('public').to_s + log_file.to_s
        new_file_path = old_file_path.sub '.txt', '_temp.txt'

        File.open(old_file_path, 'r') do |old_file|
          File.open(new_file_path, 'w') do |new_file|
            old_file.each_line do |line|
              new_file.write(line) unless line =~ /ADL index/ or
                                          line =~ /Work job_id/ or
                                          line =~ /Generated/ or
                                          line =~ /Pushing work/ or
                                          line =~ /Selecting Pool/ or
                                          line =~ /Temperature climbed/ or
                                          line =~ /Setting GPU/ or
                                          line =~ /found something?/ or
                                          line =~ /New best share/ or
                                          line =~ /Proof:/ or
                                          line =~ /Target:/ or
                                          line =~ /TrgVal?/ or
                                          line =~ /Submitting share/ or
                                          line =~ /OCL NONCE/ or
                                          line =~ /PROOF OF WORK RESULT/ or
                                          line =~ /Share above target/ or
                                          line =~ /Discarded work/ or
                                          line =~ /ATI ADL Overdrive/ or
                                          line =~ /Testing Pool/ or
                                          line =~ /API not running/ or
                                          line =~ /New block/ or
                                          line =~ /Get work blocked/ or
                                          line =~ /Got work from get queue/ or
                                          line =~ /Temperature rising/ or
                                          line =~ /Temperature dropping/ or
                                          line =~ /at Pool/ or
                                          line =~ /Failed to connect/ or
                                          line =~ /setup_stratum_socket/ or
                                          line =~ /stratum failed/ or
                                          line =~ /job_id/ or
                                          line =~ /Discarded cloned/ or
                                          line =~ /work to stratum queue/ or
                                          line =~ /Successfully submitted/ or
                                          line =~ /stratum share/ or
                                          line =~ /degrees below target/ or
                                          line =~ /detected new block/ or
                                          line =~ /Work stale due/ or
                                          line =~ /Discarded/ or
                                          line =~ /Stratum from Pool/ or
                                          line =~ /Temperature over target/ or
                                          line =~ /Deleted block/ or
                                          line =~ /Work update message/ or
                                          line =~ /Popping work/ or
                                          line =~ /Preferred vector/ or
                                          line =~ /Select timeout/
            end
          end
        end

        FileUtils.mv new_file_path, old_file_path

      end

      def extracting_platform_details

        current_file_path = Rails.root.join('public').to_s + log_file.to_s

        current_vendor = ''
        current_name = ''
        current_version = ''

        File.open(current_file_path, 'r') do |current_file|
          current_file.each_line do |line|
            current_vendor = line[line.rindex(':') + 1, line.length - line.rindex(':')].strip if line =~ /CL Platform vendor/
            current_name = line[line.rindex(':') + 1, line.length - line.rindex(':')].strip if line =~ /CL Platform name/
            current_version = line[line.rindex(':') + 1, line.length - line.rindex(':')].strip if line =~ /CL Platform version/
            break if current_vendor != '' and current_name != '' and current_version != ''
          end
        end

        platform_details = Platform.new
        platform_details.vendor = current_vendor
        platform_details.name = current_name
        platform_details.version = current_version
        platform_details.log_file_id = id
        platform_details.save

      end

      def extracting_gpus_details

        is_gpu_found = false

        current_file_path = Rails.root.join('public').to_s + log_file.to_s

        File.open(current_file_path, 'r') do |current_file|
          current_file.each_line do |line|

            if line =~ /iAdapterIndex/

              current_line = line.split(' ')
              current_vendor_id = current_line.find{|element| /iVendorID/ =~ element}
              current_name = line[line.index('name:') + 5, line.length - line.index('name:') - 5]
              current_udid = current_line.find{|element| /strUDID/ =~ element}

              gpu = Gpu.new
              gpu.name = current_name.gsub!(/\n/, '').strip
              gpu.vendorID = current_vendor_id[current_vendor_id.index(':') + 1, current_vendor_id.length - current_vendor_id.index(':') - 1]
              gpu.UDID = current_udid[current_udid.index(':') + 1, current_udid.length - current_udid.index(':') - 1]
              gpu.log_file_id = id
              gpu.save

              is_gpu_found = true
            else
              break if is_gpu_found
            end

          end
        end

      end

      def get_runtime_and_search_stats

        #extracting runtime statistics

          has_extraction_started = false

          current_file_path = Rails.root.join('public').to_s + log_file.to_s

          File.open(current_file_path, 'r') do |current_file|
            current_file.each_line do |line|

              # check where runtime statistics start
              unless has_extraction_started
                if line =~ /Summary of runtime statistics:/
                  has_extraction_started = true
                end
                next
              end

              # processing the runtime statistics
              if has_extraction_started and line.index('[') and not line =~ /Pool:/
                stats = RuntimeStatistic.new
                stats.stats = line[line.index(' ') + 1, line.length - line.index(' ') - 1].gsub(/\n/, '').strip
                stats.log_file_id = id
                stats.save
              else
                break if has_extraction_started and line =~ /Pool:/
              end

            end
          end

        #extracting search statistics

          stats = RuntimeStatistic.where({log_file_id: id})
          search_statistic = SearchStatistic.new
          search_statistic.log_file_id = id

          stats.each do |stat|

            current_stat = stat.stats

            search_statistic.average_hashrate = current_stat.gsub(/[^0-9.]/,'') if current_stat =~ /Average hashrate:/
            search_statistic.runtime_in_minutes = convert_time_to_minutes(current_stat.gsub(/[^0-9:]/,'')[1,8]) if current_stat =~ /Runtime:/
            search_statistic.start_date = current_stat[current_stat.index('[') +1, 19] if current_stat =~ /Started at /

          end

          search_statistic.save

      end

      def extracting_pool_statistics

        stats = Hash.new

        has_extraction_started = false
        are_pool_stats_extracted = false

        current_file_path = Rails.root.join('public').to_s + log_file.to_s

        current_pool_name = ''
        current_pool_stats = ''

        File.open(current_file_path, 'r') do |current_file|
          current_file.each_line do |line|

            # check where pool statistics start
            unless has_extraction_started
              if line =~ /Pool:/
                has_extraction_started = true
              else
                next
              end
            end

            # processing the pool statistics
            if has_extraction_started and line.index('[')

              if line =~ /Pool:/
                are_pool_stats_extracted = true
                current_pool_name = line[line.index('Pool:') + 5, line.length - line.index('Pool:') - 5].gsub(/\n/, '').strip
                stats[current_pool_name] = Array.new
                next
              end

              if are_pool_stats_extracted
                current_pool_stats = line[line.index(' ') + 1, line.length - line.index(' ') - 1].gsub(/\n/, '').strip
                stats[current_pool_name].push(current_pool_stats)
              end

            else
              are_pool_stats_extracted = false
            end

          end
        end

        stats.each do |name, current_stats|

          pool = Pool.new
          pool.log_file_id = id
          pool.name = name
          pool.save

          current_stats.each do |current_stat|

            stat = PoolStatistic.new
            stat.stats = current_stat
            stat.pool_id = pool.id
            stat.save

          end

        end

      end

      def extracting_gpu_stats

        has_extraction_started = false
        current_file_path = Rails.root.join('public').to_s + log_file.to_s

        File.open(current_file_path, 'r') do |current_file|
          current_file.each_line do |line|

            # check where device statistics start
            unless has_extraction_started
              if line =~ /Summary of per device statistics:/
                has_extraction_started = true
              end
              next
            end

            # processing the device statistics
            if has_extraction_started and line.index('[') and line.index('GPU')

              current_line = line.gsub(/\n/, '').strip
              current_details = current_line[current_line.index(']') + 1, current_line.length - current_line.index(']') - 1].split('|')

              # stats extraction
              current_name = current_details[0].strip
              current_last_five_seconds = current_details[1].split(' ')[0].split(':')[1]
              current_average = current_details[1].split(' ')[1].split(':')[1]
              current_accepted = current_details[2].split(' ')[0].split(':')[1]
              current_rejected = current_details[2].split(' ')[1].split(':')[1]
              current_hardware_errors = current_details[2].split(' ')[2].split(':')[1]
              current_work_utility = current_details[2].split(' ')[3].split(':')[1]

              # inserting records
              gpu = GraphicsProcessingUnit.new
              gpu.log_file_id = id
              gpu.name = current_name
              gpu.save

              gpus = GraphicsProcessingUnitStat.new
              gpus.graphics_processing_unit_id = gpu.id
              gpus.average = current_average
              gpus.last_five_seconds = current_last_five_seconds
              gpus.accepted = current_accepted
              gpus.rejected = current_rejected
              gpus.hardware_errors = current_hardware_errors
              gpus.work_utility = current_work_utility
              gpus.save

            end

          end
        end

      end

      def extracting_events

        connection = ActiveRecord::Base.connection

        inserts = Array.new

        log_event_types = LogEventType.all

        temp_type_id = log_event_types.find_by_event_type('temp').as_json['id']
        thread_type_id = log_event_types.find_by_event_type('thread').as_json['id']
        overall_type_id = log_event_types.find_by_event_type('overall').as_json['id']
        diff_type_id = log_event_types.find_by_event_type('diff').as_json['id']

        current_file_path = Rails.root.join('public').to_s + log_file.to_s

        prev_time = ''
        index = 0

        time_now = Time.now.to_s

        File.open(current_file_path, 'r') do |current_file|
          current_file.each_line do |line|

            type_id = case line
                       when /#{Regexp.escape('[thread')}/
                         thread_type_id
                       when /Network/
                         diff_type_id
                       when /#{Regexp.escape('] (5s):')}/
                         overall_type_id
                       when /C  F:/
                         temp_type_id
                       else 0
                     end

            if type_id != 0

              curr_time = line[1,line.index(']') - 1]

              if prev_time != curr_time
                index = +1
                prev_time = curr_time
              end

              event = line[line.index(']') + 1,line.length-line.index(']')].gsub(/\n/, '').strip
              inserts.push '(' +  index.to_s + ", '" + event + "', " + type_id.to_s + ", '" + time_now + "', '" + time_now + "', " + id.to_s + ')'

            end

          end
        end

        sql = "INSERT INTO log_events (row_number, event, log_event_type_id, created_at, updated_at, log_file_id) VALUES #{inserts.join(", ")}"
        connection.execute sql

      end

end
