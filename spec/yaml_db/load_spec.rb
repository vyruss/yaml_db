require 'active_support/core_ext/kernel/debugger'

module YamlDb
  RSpec.describe Load do

    before do
      allow(SerializationHelper::Utils).to receive(:quote_table).with('mytable').and_return('mytable')

      allow(ActiveRecord::Base).to receive(:connection).and_return(double('connection').as_null_object)
      allow(ActiveRecord::Base.connection).to receive(:transaction).and_yield
    end

    before(:each) do
      @io = StringIO.new
      @parser = YAML::Parser.new(SerializationHelper::LoadHandler.new)
    end

    it "calls load structure for each document in the file" do
      expect(@parser).to be_a YAML::Parser
      expect(@parser).to receive(:parse).with(@io)
    end

    it "calls load structure when the document in the file contains no records" do
      expect(YAML).to receive(:parse).with(@io)
      expect(Load).not_to receive(:load_table)
      Load.load(@io)
    end

  end
end
