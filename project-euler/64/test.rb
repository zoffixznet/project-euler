# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

require "code.rb"

describe "Testing" do

    it "should yield good results" do
        23.continued_fraction.should eql([[4],[1,3,1,8]])
        2.continued_fraction.should eql([[1],[2]])
        3.continued_fraction.should eql([[1],[1,2]])
        5.continued_fraction.should eql([[2],[4]])
        6.continued_fraction.should eql([[2],[2,4]])

    end
end
