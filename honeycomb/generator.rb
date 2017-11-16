require 'faker'
require 'csv'

class Generator
  #
  # Utility tool to create training and test data
  # for Jigsaw. Records are fake and are generated
  # using the Faker gem. Will generate csv's to be
  # used with Jigsaw training models.
  #

  def initialize
    puts "Table name: "
    table_name = gets.chomp

    return "Table name cannot be nil" if table_name.empty?

    puts "# of records for #{table_name} - (default 1000): "
    total_records = gets.chomp

    data = generate_data(total_records)
    write_data_to_csv(data, table_name)
  end

  def generate_data(total_records)
    total_records = total_records.to_i unless total_records.nil?
    total_records = 1000 if total_records.nil?

    temp_array = []
    temp_array.push(HEADERS)

    0..total_records.times do |id|
      row = []
      row.push(
        id, first_name, last_name, address_street,
        address_city, address_state, address_zipcode,
        date_of_birth, phone)

      temp_array.push(row)
    end

    temp_array
  end

  def write_data_to_csv(data, table_name)
    return if data.empty?

    File.open("#{table_name}.csv", "w") {|f|
      f.write(data.inject([]) { |csv, row|
        csv << CSV.generate_line(row)
      }.join(""))
    }
  end

  def first_name
    Faker::Name.first_name
  end

  def last_name
    Faker::Name.last_name
  end

  def address_street
    Faker::Address.street_address
  end

  def address_city
    Faker::Address.city
  end

  def address_state
    Faker::Address.state_abbr
  end

  def address_zipcode
    Faker::Address.zip
  end

  def date_of_birth
    (Time.now - rand(15552000)).strftime('%Y/%m/%d')
  end

  def phone
    Faker::PhoneNumber.phone_number
  end

  HEADERS = [
    'id',
    'first_name',
    'last_name',
    'address_street',
    'address_city',
    'address_state',
    'address_zipcode',
    'date_of_birth',
    'phone'
  ].freeze
end

Generator.new()
