require 'spec_helper'

module ActiveRecordExtSpec

  class BaseRecord < ActiveRecord::Base
    self.table_name = 'records'
  end

  class ExtendedRecord < ActiveType::Record[BaseRecord]
  end
  
end

describe ActiveRecord::Base do
  
  describe '.becomes' do
    
    it 'casts a scope to a scope of another class' do
      record = ActiveRecordExtSpec::BaseRecord.create!(persisted_string: 'foo')
      base_scope = ActiveRecordExtSpec::BaseRecord.where(persisted_string: 'foo')
      casted_scope = base_scope.becomes(ActiveRecordExtSpec::ExtendedRecord)
      # casted_scope = ActiveRecordExtSpec::ExtendedRecord.scoped.merge(base_scope)
      
      
      # ActiveType.cast(current_scope, ActiveRecordExtSpec::ExtendedRecord)
      # casted_scope = ActiveRecordExtSpec::BaseRecord.scoped
      # p casted_scope
      # p casted_scope.klass
      # casted_scope.should be_a(ActiveRecord::Relation)
      # casted_scope = casted_scope.scoped
      casted_scope.build.should be_a(ActiveRecordExtSpec::ExtendedRecord)
      found_record = casted_scope.find(record.id)
      found_record.persisted_string.should == 'foo'
      found_record.should be_a(ActiveRecordExtSpec::ExtendedRecord)
    end
    
    it 'preserves existing scope conditions' do
      match = ActiveRecordExtSpec::BaseRecord.create!(persisted_string: 'foo')
      no_match = ActiveRecordExtSpec::BaseRecord.create!(persisted_string: 'bar')
      base_scope = ActiveRecordExtSpec::BaseRecord.where(persisted_string: 'foo')
      casted_scope = base_scope.becomes(ActiveRecordExtSpec::ExtendedRecord)
      casted_match = ActiveRecordExtSpec::ExtendedRecord.find(match.id)
      casted_scope.to_a.should == [casted_match]
    end
    
  end

end
