require 'spec_helper'

describe Party do
  it { should have_many(:players) }
end
