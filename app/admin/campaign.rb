ActiveAdmin.register Campaign do

  permit_params :name, :description, :goal, :deadline, :minimum, :category, :locality,
                :organization_id, :short_description,
                perks_attributes: [:id, :amount, :name, :maximum, :description, :_destroy],
                milestones_attributes: [:id, :name, :description, :amount, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :goal do |campaign|
      "$#{campaign.goal}"
    end
    column :deadline
    column :category do |campaign|
      t("campaigns.categories.#{campaign.category}")
    end
    column :locality
    column :aasm_state do |campaign|
      t("campaigns.states.#{campaign.aasm_state}")
    end
    actions
    column do |campaign|
      if campaign.aasm_state == 'pending' || campaign.aasm_state == 'rejected'

        link_to t('active_admin.approve'), approve_campaign_admin_campaign_path(campaign),
                class: 'button'
      else
        if campaign.aasm_state == 'approved'
          link_to t('active_admin.start'), start_campaign_admin_campaign_path(campaign),
                  class: 'button'
        end
      end
    end
    column do |campaign|
      if campaign.aasm_state == 'pending'
        link_to t('active_admin.reject'), reject_campaign_admin_campaign_path(campaign),
                class: 'button'
      end
    end
  end

  member_action :start_campaign do
    Campaign.find(params[:id]).start!
    redirect_to :back
  end

  member_action :approve_campaign do
    Campaign.find(params[:id]).approve!
    redirect_to :back
  end

  member_action :reject_campaign do
    Campaign.find(params[:id]).reject!
    redirect_to :back
  end

  filter :organization
  filter :name
  filter :category,
         as: :select,
         collection: Campaign::CATEGORIES.map { |c| [I18n.t("campaigns.categories.#{c}"), c] }
  filter :goal
  filter :locality
  filter :aasm_state,
         as: :select,
         collection: Campaign::STATES.map { |c| [I18n.t("campaigns.states.#{c}"), c] }

  form do |f|
    f.inputs Campaign.model_name.human do
      f.input :name
      f.input :description
      f.input :goal, min: 0.0
      f.input :deadline, as: :datepicker
      f.input :minimum, min: 0.0
      f.input :category,
              as: :select,
              collection: Campaign::CATEGORIES.map { |c| [t("campaigns.categories.#{c}"), c] }
      f.input :locality
      f.input :organization
      f.input :short_description
      f.has_many :perks do |cf|
        cf.input :amount, min: 0.0
        cf.input :name
        cf.input :maximum, min: 1
        cf.input :description
        cf.input :_destroy, as: :boolean, required: false, label: t('active_admin.remove')
      end
      f.has_many :milestones do |mf|
        mf.input :name
        mf.input :description
        mf.input :amount, min: 1.0
        mf.input :_destroy, as: :boolean, required: false, label: t('active_admin.remove')
      end
    end
    f.actions
  end

  show do |campaign|
    attributes_table do
      row :name
      row :description
      row :goal do
        "$ #{campaign.goal}"
      end
      row :deadline
      row :minimum do
        "$ #{campaign.minimum}"
      end
      row :category do
        t("campaigns.categories.#{campaign.category}")
      end
      row :locality
      row :organization
      row :short_description
      row :created_at
      row :aasm_state do |c|
        t("campaigns.states.#{c.aasm_state}")
      end
    end
    panel Perk.model_name.human(count: 2) do
      if campaign.perks.empty?
        t('application.no_results')
      else
        table_for campaign.perks do
          column Perk.human_attribute_name(:amount), :amount do |perk|
            "$ #{perk.amount}"
          end
          column Perk.human_attribute_name(:name), :name
          column Perk.human_attribute_name(:description), :description
          column Perk.human_attribute_name(:maximum), :maximum
        end
      end
    end
    panel Milestone.model_name.human(count: 2) do
      if campaign.milestones.empty?
        t('application.no_results')
      else
        table_for campaign.milestones do
          column Milestone.human_attribute_name(:name), :name
          column Milestone.human_attribute_name(:description), :description
          column Milestone.human_attribute_name(:aasm_state) do |milestone|
            t("milestones.states.#{milestone.aasm_state}")
          end
          column Milestone.human_attribute_name(:amount), :amount
          column do |milestone|
            if milestone.aasm_state == 'achieved'
              link_to t('active_admin.approve'), approve_milestone_admin_campaign_path(milestone),
                      class: 'button'
            end
          end
          column do |milestone|
            if milestone.aasm_state == 'achieved'
              link_to t('active_admin.reject'), reject_milestone_admin_campaign_path(milestone),
                      class: 'button'
            end
          end
          column do |milestone|
            if milestone.aasm_state == 'notAchieved' || milestone.aasm_state == 'rejected'
              link_to t('active_admin.achieve'), achieve_milestone_admin_campaign_path(milestone),
                      class: 'button'
            end
          end
        end
      end
    end
    panel Contribution.model_name.human(count: 2) do
      if campaign.contributions.empty?
        t('application.no_results')
      else
        table_for campaign.contributions do
          column Contribution.human_attribute_name(:amount), :amount do |contribution|
            "$ #{contribution.amount}"
          end
          column Contribution.human_attribute_name(:user), :user do |contribution|
            if contribution.user.present?
              contribution.user.full_name
            elsif contribution.first_name.present? || contribution.last_name.present?
              "#{contribution.first_name} #{contribution.last_name}"
            else
              '-'
            end
          end
          column User.human_attribute_name(:email), :email do |contribution|
            contribution.email || contribution.user.try(:email) || '-'
          end
          column Contribution.human_attribute_name(:phone), :phone
          column Contribution.human_attribute_name(:perk), :perk
          column Contribution.human_attribute_name(:created_at), :created_at
          column Purchase.human_attribute_name(:status), :status do |contribution|
            t("purchase.status.#{contribution.purchase.try(:status)}")
          end
        end
      end
    end
    active_admin_comments
  end

  member_action :approve_milestone do
    Milestone.find(params[:id]).approve!
    redirect_to :back
  end

  member_action :reject_milestone do
    Milestone.find(params[:id]).reject!
    redirect_to :back
  end

  member_action :achieve_milestone do
    Milestone.find(params[:id]).achieve!
    redirect_to :back
  end
end
