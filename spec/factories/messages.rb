FactoryBot.define do
  factory :message do
    title FFaker::Lorem.sentence
    description FFaker::Lorem.paragraph
  end
end
