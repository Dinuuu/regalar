require 'spec_helper'

describe OrganizationPolicy do
  subject { OrganizationPolicy }

  # permissions :update? do
  #   it "denies access if post is published" do
  #     expect(subject).not_to permit(User.new(:admin => false), Post.new(:published => true))
  #   end

  #   it "grants access if post is published and user is an admin" do
  #     expect(subject).to permit(User.new(:admin => true), Post.new(:published => true))
  #   end

  #   it "grants access if post is unpublished" do
  #     expect(subject).to permit(User.new(:admin => false), Post.new(:published => false))
  #   end
  # end
end
