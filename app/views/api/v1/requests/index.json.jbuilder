json.attackGroups do
  json.array!(@attack_groups) do |attack_group|
    json.groupNumber  attack_group.group_number
    json.attackers do
      json.array!(attack_group.attackers.is_participant) do |attacker|
        json.name   attacker.user.user_profile.name
        json.image  attacker.user.user_profile.image.icon.url
      end
    end
  end
end