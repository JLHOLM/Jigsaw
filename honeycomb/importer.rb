require 'csv'
require 'pg'

class Importer
  def initialize(table_name, file)
    @table_name = table_name
    @file = file

    drop_table
    progress_print("Dropping #{@table_name}")

    create_table
    progress_print("Creating #{@table_name}")

    prepare_insert_statement
  end

  def import
    progress_print("Importing Data Into #{@table_name}")

    CSV.foreach(@file, headers: true) do |person|
      insert_person(person)
    end
  end

  def prepare_insert_statement
    CONN.prepare("#{@table_name}_insert_person", "insert into #{@table_name} (first_name, last_name, address_street, address_city, address_state, address_zipcode, date_of_birth, phone) values ($1, $2, $3, $4, $5, $6, $7, $8)")
  end

  def insert_person(person)
    CONN.exec_prepared("#{@table_name}_insert_person", [person[0], person[1], person[2], person[3], person[4], person[5], person[6], person[7]])
  end

  def drop_table
    return if table_exists.getvalue(0,0) == "0"
    CONN.exec("DROP TABLE #{@table_name}")
  end

  def create_table
    CONN.exec("CREATE TABLE #{@table_name} (id serial NOT NULL, first_name character varying(255), last_name character varying(255), address_street character varying(255), address_city character varying(255), address_state character varying(255), address_zipcode character varying(255), date_of_birth character varying(255), phone character varying(255), CONSTRAINT #{@table_name}_pkey PRIMARY KEY (id)) WITH (OIDS=FALSE);")
  end

  def table_exists
    CONN.exec("SELECT count(*) FROM information_schema.tables WHERE table_name = '#{@table_name}'")
  end

  def progress_print(action_name)
    0.upto(100) do |i|
      printf("\r#{action_name}: %d%", i)
      sleep(0.001)
    end
    puts
  end

  CONN = PG::Connection.open(dbname: 'Jigsaw')
end
