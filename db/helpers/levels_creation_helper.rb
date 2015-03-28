#encoding: utf-8
module LevelsCreationHelper

  class << self

    def create_levels
      puts 'Creating Levels'

      0.upto(10) do |time|
        level = Level.create(
          level: time + 1,
          title: Faker::Lorem.word,
          from: (time * 10),
          to: (time + 1) * 10
        )
      end
      puts 'Finished Creating Levels'
    end
  end
end
