module ActiveType
  module ActiveRecordExt

    def becomes(other_class)
      # other_class.where('1=1').merge(where('1=1'))
      # p other_class
      # other_class.scoped #.merge(scoped)
      # other_class.scoped
      # p '****' , other_class
      self.abstract_class = true
      other_scope = other_class.where(nil)
      self.abstract_class = false
      other_scope.merge(where(nil))
    end

    ActiveRecord::Base.extend(self)
    
  end
end
