class User::AttackGroupsController < ApplicationController
  def new
    @attack_group = current_user.attack_groups
  end
end
