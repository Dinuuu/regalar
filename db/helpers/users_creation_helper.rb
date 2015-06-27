#encoding: utf-8
module UsersCreationHelper

  class << self

    def create_users
      puts 'Creating Users'

      create_user('mmarquez@gmail.com', '123123123', 'Martin', 'Marquez',
                  'http://www.dcrgraphs.net/Images/Profile/default.png')
      create_user('dinu1389@gmail.com', '123123123', 'Federico', 'Di Nucci',
                  'http://www.dcrgraphs.net/Images/Profile/default.png')
      create_user('victoria.mesa.alcorta@gmail.com', '123123123', 'Victoria', 'Mesa Alcorta',
                  'http://www.dcrgraphs.net/Images/Profile/default.png')
      create_user('lulirez@gmail.com', '123123123', 'Luciana', 'Reznik  ',
                  'http://www.dcrgraphs.net/Images/Profile/default.png')

      puts 'Finished Creating Users'
    end

    private

    def create_user(email, password, first_name, last_name, avatar)
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password,
        first_name: first_name,
        last_name: last_name,
        remote_avatar_url: avatar
      )
      user.skip_confirmation!
      user.save!
    end
  end

end
