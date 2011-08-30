require 'rubygems'
require 'sequel'
require 'mime/types'
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
@a.add_attachs(@b)
@a.save

