#encoding: utf-8
module OrganizationsCreationHelper

  class << self

    def create_organizations(times)
      puts 'Creating Organizations'

      1.upto(times) do |time|
        organization = Organization.create(
          name: "Organization #{time}",
          description: Faker::Lorem.sentence,
          locality: Faker::Address.city,
          user_ids: User.all.pluck(:id).sample(rand(1..User.count))
        )
      end

      puts 'Finished Creating Organizations'
    end
  end
end
