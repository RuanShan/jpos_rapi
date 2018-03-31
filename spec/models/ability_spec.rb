require 'rails_helper'
include Warden::Test::Helpers

describe Ability do

  describe 'User Role' do
    let!(:user) { create(:user, role: 'user') }
    before do
      login_as user
    end

    it 'can :read users' do
      expect(Ability.new(user)).to be_able_to(:read, User.new)
    end
    it 'cannot :manage users' do
      expect(Ability.new(user)).to_not be_able_to(:manage, User.new)
    end
  end

  describe 'Manager Role' do
    let!(:user) { create(:user, role: 'manager') }
    before do
      login_as user
    end

    it 'can :read users' do
      expect(Ability.new(user)).to be_able_to(:read, User.new)
    end
    it 'can :create users' do
      expect(Ability.new(user)).to be_able_to(:create, User.new)
    end
    it 'cannot :destroy users' do
      expect(Ability.new(user)).to_not be_able_to(:destroy, User.new)
    end
  end

  describe 'Admin Role' do
    let!(:user) { create(:user, role: 'admin') }
    before do
      login_as user
    end

    it 'can :read users' do
      expect(Ability.new(user)).to be_able_to(:read, User.new)
    end
    it 'can :manage users' do
      expect(Ability.new(user)).to be_able_to(:manage, User.new)
    end
  end
end
