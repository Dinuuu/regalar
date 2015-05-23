#encoding: utf-8
module LevelsCreationHelper

  class << self

    def create_levels
      puts 'Creating Levels'
      Level.create(level: 1, title: 'Generoso', from: 0, to: 10)
      Level.create(level: 1, title: 'Caritativo', from: 11, to: 20)
      Level.create(level: 1, title: 'Donador Recurrente', from: 21, to: 30)
      Level.create(level: 1, title: 'Virgen de Calcuta', from: 31, to: 40)
      Level.create(level: 1, title: 'Robin Hood', from: 41, to: 50)
      Level.create(level: 1, title: 'Dios', from: 51, to: 60)
      puts 'Finished Creating Levels'
    end
  end
end
