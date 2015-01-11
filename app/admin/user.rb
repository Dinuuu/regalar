ActiveAdmin.register User do

  permit_params :first_name, :last_name, :email, :avatar

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :sign_in_count
    column :last_sign_in_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email

  show do |user|
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :avatar
    end
    panel Contribution.model_name.human(count: 2) do
      if user.contributions.empty?
        t('application.no_results')
      else
        table_for user.contributions do
          column Contribution.human_attribute_name(:amount), :amount do |contribution|
            "$ #{contribution.amount}"
          end
          column Contribution.human_attribute_name(:campaign), :campaign
          column Contribution.human_attribute_name(:perk), :perk
          column Contribution.human_attribute_name(:created_at), :created_at
          column Purchase.human_attribute_name(:status), :status do |contribution|
            t("purchase.status.#{contribution.purchase.status}")
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs User.model_name.human do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.actions
    end
  end

end
