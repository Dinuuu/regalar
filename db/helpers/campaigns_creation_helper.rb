#encoding: utf-8
module CampaignsCreationHelper

  class << self

    def create_campaigns(times)
      puts 'Creating Campaigns'

      1.upto(times) do |time|
        create_campaign(time)
      end

      puts 'Finished Creating Campaigns'
    end

    private

    def create_campaign(time)
      campaign = Campaign.create(
        name: "Campaign #{time}",
        description: Faker::Lorem.paragraph,
        deadline: DateTime.current + rand(10..60).days,
        minimum: 1.0,
        goal: 1.0, # Then this will be updated by milestones
        category: Campaign::CATEGORIES.sample.to_s,
        locality: Faker::Address.city,
        country: Faker::Address.country,
        short_description: Faker::Lorem.sentence,
        organization: Organization.all.sample,
        video: 'http://www.youtube.com/watch?v=hT6uXI60po4'
      )
      create_perks(campaign, rand(2..10))
      create_milestones(campaign, rand(2..10))
      update_goal(campaign)
      create_contributions(campaign, rand(0..30))
      campaign.save!
    end

    def create_perks(campaign, times)
      1.upto(times) do |time|
        Perk.create(
          amount: rand(10..2000),
          name: Faker::Commerce.product_name,
          maximum: rand(5..30),
          description: Faker::Lorem.sentence,
          campaign: campaign
        )
      end
    end

    def create_milestones(campaign, times)
      1.upto(times) do |time|
        Milestone.create(
          name: Faker::Commerce.product_name,
          description: Faker::Lorem.paragraph,
          amount: rand(1..20000),
          campaign: campaign
        )
      end
    end

    def update_goal(campaign)
      campaign.goal = 0.0
      campaign.milestones.each { | milestone | campaign.goal += milestone.amount }
    end

    def create_contributions(campaign, times)
      1.upto(times) do |time|
        amount = rand(10..2000)
        contribution = Contribution.create(
          user: User.all.sample,
          perk: campaign.perks.sample,
          amount: amount,
          campaign: campaign
        )
        campaign.add_contribution(amount)
        Purchase.create(status: :success, contribution: contribution)
      end
    end
  end
end
