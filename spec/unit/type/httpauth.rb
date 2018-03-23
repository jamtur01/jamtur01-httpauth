#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../../spec_helper'

describe Puppet::Type.type(:httpauth) do
    it "should default to being present" do
        user = Puppet::Type.type(:httpauth).new(:username => "alice", :password => "password")
        user.should(:ensure).should == :present
    end
end

describe Puppet::Type.type(:httpauth), "when validating attributes" do
    [:name, :password, :realm, :mechanism, :file].each do |param|
        it "should have a #{param} parameter" do
            Puppet::Type.type(:httpauth).attrtype(param).should == :param
        end
    end

    it "should have an ensure property" do
        Puppet::Type.type(:httpauth).attrtype(:ensure).should == :property
    end
end

describe Puppet::Type.type(:httpauth), "when validating attribute values" do
    before do
        @provider = stub 'provider', :class => Puppet::Type.type(:httpauth).defaultprovider, :clear => nil
        Puppet::Type.type(:httpauth).defaultprovider.expects(:new).returns(@provider)
    end

    it "should support :present as a value to :ensure" do
        Puppet::Type.type(:httpauth).new(:username => "alice", :ensure => :present, :password => "password")
    end

    it "should support :absent as a value to :ensure" do
        Puppet::Type.type(:httpauth).new(:username => "alice", :ensure => :absent, :password => "password")
    end

    it "should support :basic as a value to :mechanism" do
        Puppet::Type.type(:httpauth).new(:username => "alice", :mechanism => :basic, :password => "password")
    end

    it "should support :digest as a value to :mechanism" do
        Puppet::Type.type(:httpauth).new(:username => "alice", :mechanism => :digest, :password => "password")
    end 
end

module HTTPAuthEvaluationTesting
    def setprops(properties)
        @provider.stubs(:properties).returns(properties)
    end
end

describe Puppet::Type.type(:httpauth) do
    before :each do
        @provider = stub 'provider', :class => Puppet::Type.type(:httpauth).defaultprovider, :clear => nil, :satisfies? => true, :name => :mock
        Puppet::Type.type(:httpauth).defaultprovider.stubs(:new).returns(@provider)
        Puppet::Type.type(:httpauth).defaultprovider.stubs(:instances).returns([])
        @httpauth = Puppet::Type.type(:httpauth).new(:username => "alice", :password => "password")

        @catalog = Puppet::Resource::Catalog.new
        @catalog.add_resource(@httpauth)
    end

    describe Puppet::Type.type(:httpauth), "when it should be absent" do
        include HTTPAuthEvaluationTesting

        before { @httpauth[:ensure] = :absent }

        it "should do nothing if it is :absent" do
                @provider.expects(:properties).returns(:ensure => :absent)
                @catalog.apply
        end

        it "should delete if it is :present" do
                @provider.stubs(:properties).returns(:ensure => :present)
                @provider.expects(:destroy)
                @catalog.apply
        end
    end

    describe Puppet::Type.type(:httpauth), "when it should be present" do
        include HTTPAuthEvaluationTesting

        before { @httpauth[:ensure] = :present }

        it "should do nothing if it is :present" do
                @provider.expects(:properties).returns(:ensure => :present)
                @catalog.apply
        end

        it "should create if it is :absent" do
                @provider.stubs(:properties).returns(:ensure => :absent)
                @provider.expects(:create)
                @catalog.apply
        end
    end
end
