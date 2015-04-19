ActiveAdmin.register Organization do
  permit_params :name, :description, :locality, :website, :email, :logo

  index do
    selectable_column
    id_column
    column :email
    column :website
    column :name
    column :description
    column :locality
    column :created_at
    actions
  end
  filter :website
  filter :email
  filter :name
  filter :description
  filter :locality
end
