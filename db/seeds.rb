# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Inserting default access types
types = {

    public: {

        name: 'public',
        description: 'Log file is visible by everyone.'
    },

    protected: {

        name: 'protected',
        description: 'Log file is visible by authenticated users only.'
    },

    private: {

        name: 'private',
        description: 'Log file is not visible by other users.'
    }
}

types.each do |access_type, data|

  type = AccessType.new(data)

  unless AccessType.where(name: type.name).exists?
    type.save!
  end
end

# Inserting default security users
users = {

    admin: {

        username: 'admin',
        email: 'tuvarna.system.master@gmail.com',
        password: 'adminpass',
        password_confirmation: 'adminpass',
        is_admin: true
    },

    administrator: {

        username: 'administrator',
        email: 'tuvarna.system.super.user@gmail.com',
        password: 'administrator',
        password_confirmation: 'administrator',
        is_admin: true
    }
}

users.each do |user, data|

  user = User.new(data)

  unless User.where(email: user.email).exists?
    user.save!
  end
end

# Inserting default log event types
types = %w(temp thread overall diff)

types.each do |current_type|

  type = LogEventType.new
  type.event_type = current_type

  unless LogEventType.where(event_type: current_type).exists?
    type.save!
  end
end

# Inserting default log event types

log_files = {

    log_file_01: {

        name: 'demo log file 01',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_01.txt')),
        access_type_id: 1,
        user_id: User.find_by_username('administrator').id
    },

    log_file_02: {

        name: 'demo log file 02',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_02.txt')),
        access_type_id: 2,
        user_id: User.find_by_username('administrator').id
    },

    log_file_03: {

        name: 'demo log file 03',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_03.txt')),
        access_type_id: 1,
        user_id: User.find_by_username('administrator').id
    },

    log_file_04: {

        name: '(paging) demo log file 04',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_04.txt')),
        access_type_id: 1,
        user_id: User.find_by_username('administrator').id
    },

    log_file_05: {

        name: '(paging) demo log file 05',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_05.txt')),
        access_type_id: 3,
        user_id: User.find_by_username('administrator').id
    },

    log_file_06: {

        name: '(paging) demo log file 06',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_06.txt')),
        access_type_id: 3,
        user_id: User.find_by_username('administrator').id
    },

    log_file_07: {

        name: '(paging) demo log file 07',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_07.txt')),
        access_type_id: 1,
        user_id: User.find_by_username('administrator').id
    },

    log_file_08: {

        name: '(paging) demo log file 08',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_08.txt')),
        access_type_id: 3,
        user_id: User.find_by_username('administrator').id
    },

    log_file_09: {

        name: '(paging) demo log file 09',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_09.txt')),
        access_type_id: 2,
        user_id: User.find_by_username('administrator').id
    },

    log_file_10: {

        name: '(paging) demo log file 10',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_10.txt')),
        access_type_id: 2,
        user_id: User.find_by_username('administrator').id
    },

    log_file_11: {

        name: '(paging) demo log file 11',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_11.txt')),
        access_type_id: 2,
        user_id: User.find_by_username('administrator').id
    },

    log_file_12: {

        name: '(paging) demo log file 12',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_12.txt')),
        access_type_id: 3,
        user_id: User.find_by_username('administrator').id
    },

    log_file_13: {

        name: '(paging) demo log file 13',
        description: 'This is sample demonstration log file.',
        log_file: File.new(File.join(Rails.root, '/public/log_files/log_debug_13.txt')),
        access_type_id: 1,
        user_id: User.find_by_username('administrator').id
    }
}

log_files.each do |file_name, data|

  file = LogFile.new(data)

  unless LogFile.where(name: file.name).exists?
    file.build_config_file
    file.save!
    file.process_uploaded_file
  end
end
