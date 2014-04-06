require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }

  it 'can be a doubles match or not' do
		match = Match.create(doubles_match: false)
		expect(match.doubles_match).to eq false
	end

end
