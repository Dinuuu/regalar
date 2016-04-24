#encoding: utf-8
module LevelsCreationHelper

  class << self

    def create_levels
      puts 'Creating Levels'
      Level.create(level: 1, title: 'Generoso', from: 0, to: 10)
      Level.create(level: 2, title: 'Caritativo', from: 11, to: 20)
      Level.create(level: 3, title: 'Donador Recurrente', from: 21, to: 30)
      Level.create(level: 4, title: 'Robin Hood', from: 31, to: 40)
      Level.create(level: 5, title: 'Teresa de Calcuta', from: 41, to: 1_000_000)
      puts 'Finished Creating Levels'
    end
  end
end
