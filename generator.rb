#!/usr/bin/env ruby

require 'faker'
require 'csv'
require 'active_support/all'

fileName="out/ITCases.csv"

casePriority=["High","Medium","Low"]
caseStatus=["Closed","On-hold","Blocked","Open"]

# Creating an array of users who may raise a ticket
users = Array.new

for i in 0..499
  users.push(Faker::Name.name)
end

# Creating an array of agent group
agentGroups = Array.new
for i in 0..4
  agentGroups.push(Faker::Job.field)
end

# Creating an array of case category
caseCategories = Array.new
for i in 0..4
  caseCategories.push(Faker::Hacker.ingverb + " " + Faker::Hacker.noun)
end

# Creating an array of agent that may treat a ticket
agents = Array.new

for i in 0..14
  agents.push({
    "name" => Faker::Name.name,
    "group" => agentGroups[rand(0..(agentGroups.length-1))]

  })
end


# Generating cases
cases = Array.new
for i in 1..10000
  agent = agents[rand(0..(agents.length-1))]
  cStatus = caseStatus[rand(0..(caseStatus.length-1))]
  oDate = Faker::Date.between(2.years.ago, Date.today)
  cDate = (cStatus == "Closed" ? Faker::Date.between(oDate, oDate+50.days).to_s : "");

  cases.push({
    caseN: i,
    caseDescription: Faker::Hacker.say_something_smart,
    openDate: oDate,
    closeDate: cDate,
    caseCategory: caseCategories[rand(0..(caseCategories.length-1))],
    casePriority: casePriority[rand(0..(casePriority.length-1))],
    user: users[rand(0..(users.length-1))],
    caseStatus: cStatus,
    agent: agent["name"],
    agentGroup: agent["group"]
  })
end


=begin
puts "\n\n*** printing users list"
puts users
puts "\n\n*** printing agents list"
puts agents
=end

#puts cases

# Writing CSV Header
CSV.open(fileName, "wb") do |csv|
  csv << ["Case #", "Case Description", "Open Date","Close Date","Case Category","Case Priority","User","Case Status","Agent","Agent Group"]
end

# Writing rows
cases.each do |aCase|
  CSV.open(fileName, "a+") do |csv|
    csv << [aCase[:caseN],aCase[:caseDescription],aCase[:openDate],aCase[:closeDate],aCase[:caseCategory],aCase[:casePriority],aCase[:user],aCase[:caseStatus],aCase[:agent],aCase[:agentGroup]]
    #    csv << [aCase["Case #"], aCase["Case Description"], aCase["Open Date"].to_s,aCase["Close Date"].to_s,aCase["Case Category"],aCase["Case Priority"],aCase["User"],aCase["Case Status"],aCase["Agent"],aCase["Agent Group"]]
  end
end
