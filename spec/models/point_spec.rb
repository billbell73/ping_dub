require 'spec_helper'

describe Point do

	it { should belong_to(:winner) }
	it { should belong_to(:server) }
	it { should belong_to(:game) }

	let(:point) { Point.new(p1_on_left: true) }
  
  it 'knows which end player 1 is' do
		expect(point.p1_on_left).to equal true
	end

end
