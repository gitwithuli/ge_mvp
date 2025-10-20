# --- demo user ---
user = User.find_or_initialize_by(email: "demo@example.com")
user.password = "password"
user.save!

# --- locations (use integers with KINDS since Location has no enum DSL) ---
# country = 0, city = 2
georgia = Location.find_or_create_by!(name: "Georgia") do |l|
  l.kind = Location::KINDS[:country]
end
# In case record existed with nil kind, fix it:
georgia.update!(kind: Location::KINDS[:country]) if georgia.kind.nil?

%w[Tbilisi Batumi Kutaisi Rustavi Zugdidi Poti Telavi Gori].each do |city|
  loc = Location.find_or_create_by!(name: city, parent: georgia) do |l|
    l.kind = Location::KINDS[:city]
  end
  loc.update!(kind: Location::KINDS[:city]) if loc.kind.nil?
end

# --- categories ---
root     = Category.find_or_create_by!(name: "All")
vehicles = Category.find_or_create_by!(name: "Vehicles", parent: root)
realty   = Category.find_or_create_by!(name: "Real Estate", parent: root)
electro  = Category.find_or_create_by!(name: "Electronics", parent: root)
services = Category.find_or_create_by!(name: "Services", parent: root)

%w[Cars Motorcycles Parts].each { |n| Category.find_or_create_by!(name: n, parent: vehicles) }
%w[For Sale For Rent Daily].each { |n| Category.find_or_create_by!(name: n, parent: realty) }
%w[Phones Laptops TV].each { |n| Category.find_or_create_by!(name: n, parent: electro) }

puts "✅ Seed completed:
  - Users: #{User.count}
  - Locations: #{Location.count}
  - Categories: #{Category.count}"