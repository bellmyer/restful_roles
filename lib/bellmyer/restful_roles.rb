module Bellmyer
  module RestfulRoles
    def self.included(base)
      base.extend RoleMethods
    end
    
    module RoleMethods
      def has_roles(*roles)
        roles ||= [:member]
        unless included_modules.include? InstanceMethods
          class_inheritable_accessor :roles
          extend ClassMethods
          include InstanceMethods
        end

        self.roles = roles
        
        before_save lambda{|x| x.role ||= self.roles.first}
      end
    end
    
    module ClassMethods
      def roles
        self.roles
      end  
    end
    
    module InstanceMethods
      def authorized?(requested_role)
        self.class.roles.index(self.role) >= self.class.roles.index(requested_role)
      end

      self.class.roles.each{|r| eval "def #{r}?\n\tauthorized?(:#{r})\nend"}
    end
  end
end
