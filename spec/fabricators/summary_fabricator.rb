Fabricator(:summary) do
  date Date.today - 1
  description { Faker::Lorem.paragraph }
end
