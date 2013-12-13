require 'spec_helper'

describe Product do
  it { expect { subject.new }.to raise_error }
end
