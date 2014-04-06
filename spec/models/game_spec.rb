require 'spec_helper'

describe Game do

  it { should belong_to(:winner) }
  it { should belong_to(:match) }

  it { should have_many(:points) }

end
