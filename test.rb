require 'rspec/autorun'

###
# The following is a toy application consisting of Categories, Writers,
# Assignments, and Publications. Modules have been provided below with a
# similar interface as ActiveRecord with some hard coded data to avoid
# the need for a DB.
#
# In this scenario, you are receiving parameters sent from a client
# that you need to change into a consistent and usable object. By the time
# the parameters have reached this part in the request, we are assuming
# that we have removed any potentially dangerous or unexpected parameters.
#
# Step 1:
# Flesh out `Parameterizer.organize` in order to satisfy the tests below. In
# this example, we want to return an object with a key rename as well as
# turning IDs into the objects stored in the mock database.
#
# If a new parameter is passed into this parameterizer, it should automatically
# be included in the result.
#
# Step 2:
# Create a new way to organize parameters that are being sent to update an
# existing Publication.
###

###
# Pseudo database
###
ASSIGNMENTS = {
  1 => {
    id: 1,
    category_ids: [],
    description: 'Very detailed description',
    guidelines: 'These are great guidelines',
    title: '5 Ways to Improve Your Kitchen',
    writer_id: 1
  },
  2 => {
    id: 2,
    category_ids: [],
    description: 'Another great description',
    guidelines: 'These are incredibly clear',
    title: '3 Things to Read in 2019',
    writer_id: 2
  }
}

CATEGORIES = {
  1 => {id: 1, name: 'Advertising'},
  2 => {id: 2, name: 'Marketing'},
  3 => {id: 3, name: 'Finance'}
}

PUBLICATIONS = {
  1 => {
    id: 1,
    name: 'ClearVoice',
    url: 'https://www.clearvoice.com',
    category_ids: []
  },
  2 => {
    id: 2,
    name: 'ESPN',
    url: 'http://www.espn.com',
    category_ids: []
  }
}

WRITERS = {
  1 => {id: 1, name: 'Harry'},
  2 => {id: 2, name: 'Ron'},
  3 => {id: 3, name: 'Hermoine'}
}

###
# Fake "ActiveRecord" models
###

module Category
  def self.find(id)
    CATEGORIES[id]
  end

  def self.where(ids)
    ids.map(&method(:find))
  end
end

module Writer
  def self.find(id)
    WRITERS[id]
  end

  def self.where(ids)
    ids.map(&method(:find))
  end
end

###
# Parameterizer
###

# Doesn't need to be a module! Make it however you like.
module Parameterizer
  def self.organize(params)
  end
end

RSpec.describe Parameterizer do
  context 'when organizing assignment parameters' do
    it 'returns the params as expected' do
      params = {
        id: 1,
        category_ids: [1, 2, 3],
        description: 'This is a great description',
        name: '10 Things That Bug You About Listicle Titles',
        writer_id: 3
      }
      expect(Parameterizer.organize(params)).to eq({
        id: 1,
        categories: [CATEGORIES[1], CATEGORIES[2], CATEGORIES[3]],
        description: params[:description],
        title: params[:name],
        writer: WRITERS[3]
      })
    end

    it 'avoids returning `nil` unless explicitly specified' do
      params = {
        id: 1,
        category_ids: [1, 2, 3],
        guidelines: nil,
        name: '10 Things That Bug You About Listicle Titles',
        writer_id: 3
      }
      # Should not have `description: nil` since it is not sent
      # as a param like in the above test case
      expect(Parameterizer.organize(params)).to eq({
        id: 1,
        categories: [CATEGORIES[1], CATEGORIES[2], CATEGORIES[3]],
        guidelines: nil,
        title: params[:name],
        writer: WRITERS[3]
      })
    end
  end

  context 'when organizing publication parameters' do
    it 'returns the params as expected' do
      params = {
        id: 2,
        category_ids: [2],
        url: 'https://differenturl.com'
      }
      expect(Parameterizer.organize(params)).to eq({
        id: 2,
        categories: [CATEGORIES[2]],
        url: 'https://differenturl.com'
      })
    end
  end
end
