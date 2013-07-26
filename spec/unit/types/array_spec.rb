require 'spec_helper'

describe Attrio::Types::Array do
  context 'standard casting conventions' do
    let(:model) do
      Class.new do
        include Attrio

        define_attributes do
          attr :array_attribute, Array
        end
      end
    end

    let(:object){ model.new }

    context 'with not typecasted assignment' do
      it 'should cast space separated string' do
        object.array_attribute = 'first second third'
        object.array_attribute.should be_instance_of(Array)
        object.array_attribute.should == %w(first second third)
      end
    end

    context 'with typecasted assignment' do
      it 'should assign <Array>' do
        array = %w(first second third)

        object.array_attribute = array
        object.array_attribute.should be_instance_of(Array)
        object.array_attribute.should be_equal(array)
      end
    end
  end

  context 'overriden split and element type' do
    let(:model) do
      Class.new do
        include Attrio

        define_attributes do
          attr :array_attribute, Array, :split => ', ', :element => { :type => Date, :options => { :format => '%m/%d/%y' } }
        end
      end
    end

    let(:object){ model.new }

    context 'with not typecasted assignment' do
      it 'should cast space separated string' do
        dates = [Date.today, (Date.today + 1), (Date.today + 2)]
        string = dates.map{ |date| date.strftime('%m/%d/%y') }.join(', ')

        object.array_attribute = string
        object.array_attribute.should be_instance_of(Array)
        object.array_attribute.should == dates
      end
    end
  end
end