require 'carmen'

Spree::Country.connection.truncate :spree_countries
Spree::Country.connection.truncate :spree_states
Spree::Country.connection.truncate :spree_cities
Spree::Country.connection.truncate :spree_districts

Carmen::Country.all.each do |country|
  Spree::Country.where(
    name: country.name,
    iso3: country.alpha_3_code,
    iso: country.alpha_2_code,
    iso_name: country.name.upcase,
    numcode: country.numeric_code,
    states_required: country.subregions?
  ).first_or_create
end

country = Spree::Country.find_by(iso: "CN")
Spree::Config[:default_country_id] = country.id

# find countries that do not use postal codes (by iso) and set 'zipcode_required' to false for them.

Spree::Country.where(iso: Spree::Address::NO_ZIPCODE_ISO_CODES).update_all(zipcode_required: false)


states = YAML::load(File.read( File.join(File.dirname(__FILE__),'states.yml')))
states.each_pair{|key,state|
  Spree::State.create!({id: state['id'], name: state["name"], abbr: state["abbr"], country: country})
}


path =  File.join(File.dirname(__FILE__), 'areas.json')
json_string = File.read(path)
json = JSON.parse json_string

# add cities and districts for provice
Spree::State.all.each{|state|
  cities = json[state.name]
  raise "missing cities for provice #{ state.name} " unless cities.present?

  cities.each{ |city_name, districts|
    city = Spree::City.create!({ name: city_name, state: state})
    #districts.each{|district|
    #  Spree::District.create!({ name: district, city: city})
    #}
  }
}
