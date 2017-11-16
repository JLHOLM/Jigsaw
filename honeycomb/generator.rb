require 'faker'
require 'date'
require 'csv'
require './importer'

class Generator
  #
  # Utility tool to create training and test data
  # for Jigsaw. Records are fake and are generated
  # using the Faker gem. Will generate csv's to be
  # used with Jigsaw training models.
  #

  def initialize
  end

  def create_person
    [
      first_name,
      last_name,
      address_street,
      address_city,
      address_state,
      address_zipcode,
      date_of_birth,
      phone
    ]
  end

  def randomize_person(person)
    person[0] = random_boolean ? first_name : person[0]
    person[1] = random_boolean ? last_name : person[1]
    person[2] = random_boolean ? address_street : person[2]
    person[3] = random_boolean ? address_city : person[3]
    person[4] = random_boolean ? address_state : person[4]
    person[5] = random_boolean ? address_zipcode : person[5]
    person[6] = random_boolean ? date_of_birth : person[6]
    person[7] = random_boolean ? phone : person[7]
    person
  end

  def create_person_a(person)
    [
      person[0],
      person[1],
      person[2],
      person[3],
      person[4],
      person[5],
      person[6],
      person[7]
    ]
  end

  def create_person_b(person)
    [
      random_boolean ? fun(person[0]) : person[0], # First Name
      random_boolean ? fun(person[1]) : person[1], # Last Name
      random_boolean ? fun(person[2]) : person[2], # Address Street
      random_boolean ? fun(person[3]) : person[3], # Address City
      random_boolean ? fun(person[4]) : person[4], # Address State
      random_boolean ? fun(person[5]) : person[5], # Address Zipcode
      person[6],                                          # Date of Birth
      person[7]                                           # Phone
    ]
  end

  def fun(string)
    first, *middle, last = string.chars
    [first, middle.shuffle, last].join
  end

  def generate_data
    dataset_a = [HEADERS]
    dataset_b = [HEADERS]

    persons = 4000.times.map do
      create_person
    end
    progress_print("Generating Normalized Identities")

    1000.times do
      person = randomize_person(persons.sample)
      dataset_a << create_person_a(person)
    end
    progress_print("Generating 1st Dataset")

    1000.times do
      person = dataset_a.sample
      dataset_b << create_person_b(person)
    end
    progress_print("Generating 2nd Dataset")

    write_data_to_csv(dataset_a, "dataset_a")
    progress_print("Writing 1st Dataset To CSV")

    write_data_to_csv(dataset_b, "dataset_b")
    progress_print("Writing 2nd Dataset To CSV")

    import_to_psql('dataset_a', './dataset_a.csv')
    import_to_psql('dataset_b', './dataset_b.csv')
  end

  def random_boolean
    [
      true, false, false, true, true, false, true, false, true, true, false,
      true, true, true, false, true, false, false, true, false, true, false
    ].sample
  end

  def write_data_to_csv(data, table_name)
    return if data.empty?

    File.open("#{table_name}.csv", "w") {|f|
      f.write(data.inject([]) { |csv, row|
        csv << CSV.generate_line(row)
      }.join(""))
    }
  end

  def import_to_psql(table_name, file)
    Importer.new(table_name, file).import
  end

  def progress_print(action_name)
    0.upto(100) do |i|
      printf("\r#{action_name}: %d%", i)
      sleep(0.003)
    end
    puts
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
    Time.at(rand * Time.now.to_i).strftime("%Y-%m-%d")
  end

  def phone
    Faker::PhoneNumber.phone_number
  end

  HEADERS = [
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

Generator.new.generate_data
