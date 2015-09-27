#encoding: utf-8
module OrganizationsCreationHelper

  class << self

    def create_organizations(times)
      puts 'Creating Organizations'

      1.upto(times) do |time|
        organization = Organization.create!(
          name: Faker::Company.name,
          description: Faker::Lorem.paragraph(15),
          locality: Faker::Address.city,
          user_ids: User.all.pluck(:id).sample(rand(1..User.count)),
          email: Faker::Internet.email,
          remote_logo_url: Faker::Company.logo,
          website: Faker::Internet.url
        )
      end

      puts 'Finished Creating Organizations'
    end
  end
end
