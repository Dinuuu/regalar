#encoding: utf-8
module UsersCreationHelper

  class << self

    def create_users
      puts 'Creating Users'

      create_user('mmarquez@gmail.com', '123123123', 'Martin', 'Marquez',
                  'https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xfp1/' +
                  'v/t1.0-9/10410244_846130655406890_7935741407858924088_n' +
                  '.jpg?oh=978616bb673468a87a0d87432743e93e&oe=5571D7C3&__' +
                  'gda__=1437441866_9454d39bb19f276980c872136dd55da0')
      create_user('dinu1389@gmail.com', '123123123', 'Federico', 'Di Nucci',
                  'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-prn1/v/' +
                  't1.0-9/10255131_10205906586281207_4317753258904322772_n.jpg?' +
                  'oh=7d27d6a08a4d5e389edfe29213c918a2&oe=559C7CBA&__gda__=1436' +
                  '540509_76518bf713c05fdc93468235de735779')
      create_user('victoria.mesa.alcorta@gmail.com', '123123123', 'Victoria', 'Mesa Alcorta',
                  'https://scontent-gru.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/' +
                  '1235444_10151739861303768_116464988_n.jpg?oh=2fee70f28cb' +
                  'dee62cb8754380dd3bb90&oe=55BABC88')
      create_user('lulirez@gmail.com', '123123123', 'Luciana', 'Reznik  ',
                  'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xap1/v' +
                  '/t1.0-9/10885379_10152914495292380_112763128126974159_n.' +
                  'jpg?oh=a284d00f1cfe54dfdf4c422a727475b7&oe=559A535E&__gd' +
                  'a__=1437364071_74127d713dfabe88499b9206cb566dfb')

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
