require 'csv'
require_relative 'mailer'

def people_from_file(filename)
  people = CSV.read(filename, { headers: false })
  parsed_people = []
  people.each do |p|
    exclusions = p[5] if p[5]
    person = Person.new(id: p[0], email: p[3], name: p[1], address: p[2], details: p[4])
    person.add_exclusions(exclusions.chomp.split(';')) if !!exclusions
    parsed_people << person
  end
  parsed_people
end

def assign_exchange!(people)

  while (!people.all?{|p| p.satisfied?}) do
    recipients = Array.new(people)

    people.each do |person|
      person.giving_to = recipients.delete(recipients.reject{|r| r == person}.sample)
    end
  end

  people
end

def send_emails(people, template_file)
  return if !people.all? {|p| p.satisfied?}

  template = File.open(template_file, "r").read
  people.each do |person|
    body = template.gsub("%%NAME%%", person.name)
                   .gsub("%%GIVING_TO%%", person.giving_to.name)
                   .gsub("%%ADDRESS%%", person.giving_to.address)
                   .gsub("%%DETAILS%%", person.giving_to.details)

    Mailer.send_email(person.email, ENV['EMAIL_SUBJECT'], body, ENV['GMAIL_USER'], ENV['GMAIL_PASS'])
  end
end

class Person
  attr_accessor :id
  attr_accessor :email
  attr_accessor :name
  attr_accessor :address
  attr_accessor :details
  attr_accessor :exclusions
  attr_accessor :giving_to

  def satisfied?
    !!@giving_to && !@exclusions.include?(@giving_to.id)
  end

  def initialize(opts = {})
    @id = opts[:id]
    @email = opts[:email]
    @name = opts[:name]
    @address = opts[:address]
    @details = opts[:details]
    @exclusions = []
  end

  def add_exclusions(ids)
    @exclusions += ids
    @exclusions.uniq!
    self
  end
end
