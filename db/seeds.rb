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