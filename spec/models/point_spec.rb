require 'spec_helper'

describe Point do

	let(:point) { Point.new(p1_on_left: true) }
  
  it 'knows which end player 1 is' do
		expect(point.p1_on_left).to equal true
	end

end
