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