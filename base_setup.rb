require 'rubygems'
require 'sequel'
require 'mime/types'
require 'faker' #just for test
DB = Sequel.sqlite("database.db")
DB.create_table?(:emails) do
	primary_key :id
	String :subject, :empty => false
	String :body, :text => true
	TrueClass :send, :default => false	
end
DB.create_table?(:attachs) do
	primary_key :id
	String :types
	column :file, File
	foreign_key :email_id, :emails
end
DB.create_table?(:names)do
	primary_key :id
	String :names
	String :email, :empty => false, :unique => true
end
DB.create_table?(:lists) do
	primary_key :id
	String :title
	String :description, :text => true
end
DB.create_table?(:lists_names) do
	primary_key :id
	foreign_key :name_id, :names
	foreign_key :list_id, :lists
end
class Name < Sequel::Model(:names)
	many_to_many :lists
end
class List < Sequel::Model(:lists)
	many_to_many :names
end
class Email < Sequel::Model
	one_to_many :attachs
end
class Attach < Sequel::Model(:attachs)
	many_to_one :email
end
@a = Email.new do |x|
	x.subject = "hello"
	x.body = "OOOOOQqqqqqqqqqqQQQQQQOoKjJHbnHggffgn"
	x.save
end
@b = Attach.new do |y|
	y.types = MIME::Types.type_for("base_setup.rb").to_s
	y.file = File.open("base_setup.rb", "r").read
	y.save
end
@a.add_attach(@b)
@a.save
1.upto(10) do
	name = Name.new
	name.names = Faker::Name.name
	name.email = Faker::Internet.email
	name.save
end
1.upto(2) do |x|
	list = List.new(:title => x.to_s, :description => "not info for this list")
	list.save 
end
@list1 = List.find(:id => 1)
@names = Name.all
@names.each do |z|
	@list1.add_name(z)
	z.save
	@list1.save
end

