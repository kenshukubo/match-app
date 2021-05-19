email = "test1@gmail.com"
password = "test001"
sex = 'male'
name = "test1"

user = User.create!(
  email: email,
  password: password,
  sex: sex
) if User.find_by(email: email).blank?

UserProfile.create!(
  user: user,
  name: name,
  identified_char: SecureRandom.uuid
)

UserNotification.create!(
  user: user,
)

email = "test2@gmail.com"
password = "test002"
sex = 'female'
name = "test2"

user = User.create!(
  email: email,
  password: password,
  sex: sex
) if User.find_by(email: email).blank?

UserProfile.create!(
  user: user,
  name: name,
  identified_char: SecureRandom.uuid
)

UserNotification.create!(
  user: user,
)

email = "test3@gmail.com"
password = "test003"
sex = 'male'
name = "test3"

user = User.create!(
  email: email,
  password: password,
  sex: sex
) if User.find_by(email: email).blank?

UserProfile.create!(
  user: user,
  name: name,
  identified_char: SecureRandom.uuid
)

UserNotification.create!(
  user: user,
)

email = "test4@gmail.com"
password = "test004"
sex = 'female'
name = "test4"

user = User.create!(
  email: email,
  password: password,
  sex: sex
) if User.find_by(email: email).blank?

UserProfile.create!(
  user: user,
  name: name,
  identified_char: SecureRandom.uuid
)

UserNotification.create!(
  user: user,
)
