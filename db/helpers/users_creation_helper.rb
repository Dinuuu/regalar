#encoding: utf-8
module UsersCreationHelper

  class << self

    def create_users
      puts 'Creating Users'

      create_user('mmarquez@gmail.com', '123123123', 'Martin', 'Marquez')
      create_user('dinu1389@gmail.com', '123123123', 'Federico', 'Di Nucci')
      create_user('victoria.mesa.alcorta@gmail.com', '123123123', 'Victoria', 'Mesa Alcorta')
      create_user('mdesanti90@gmail.com', '123123123', 'Matias', 'De Santi')
      create_user('federicohomovc@gmail.com', '123123123', 'Federico', 'Homovc')

      puts 'Finished Creating Users'
    end

    private

    def create_user(email, password, first_name, last_name)
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password,
        first_name: first_name,
        last_name: last_name
      )
      user.skip_confirmation!
      user.save!
    end
  end

end
