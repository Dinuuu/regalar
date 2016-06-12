namespace :friendly_url do
  desc "add_slug_to_organization"
  task add_slug_to_organization: :environment do
    ActiveRecord::Base.transaction do
     	Organization.find_each(&:save!)
  	end
  end
  
  desc "add_slug_to_user"
  task add_slug_to_user: :environment do
    ActiveRecord::Base.transaction do
     	User.find_each(&:save!)
  	end
  end

  desc "add_slug_to_gift_item"
  task add_slug_to_gift_item: :environment do
    ActiveRecord::Base.transaction do
      GiftItem.find_each(&:save!)
    end
  end

  desc "add_slug_to_wish_item"
  task add_slug_to_wish_item: :environment do
    ActiveRecord::Base.transaction do
      WishItem.find_each(&:save!)
    end
  end
end
