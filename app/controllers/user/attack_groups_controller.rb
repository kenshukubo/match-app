class User::AttackGroupsController < ApplicationController
  def new
    @attackers = Attacker.new
    @host_friends = current_user.friend_users.where(sex: current_user.sex)
  end

  def create
    begin
      ActiveRecord::Base.transaction do
      end
    rescue => error
      p error
    end
  end
end
