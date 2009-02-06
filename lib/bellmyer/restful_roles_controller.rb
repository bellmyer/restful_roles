module Bellmyer
  module RestfulRolesController
    def self.included(base)
      base.extend RestfulRolesMethods
    end
    
    module RestfulRolesMethods
      def require_role(required_role, options={})
        unless included_modules.include? InstanceMethods
          class_inheritable_accessor :required_roles
          class_inheritable_accessor :options
          
          self.required_roles = {}
          
          include InstanceMethods
        end
        
        if options[:only]
          Array(options[:only]).each {|action| self.required_roles[action.to_sym] = required_role}
        else
          self.required_roles[:all_roles] = required_role
        end
      end
    end
    
    module InstanceMethods
      def authorized?
        required_role = self.required_roles[action_name.to_sym] || self.required_roles[:all_roles]
        
        if required_role
          current_user && current_user.authorized?(required_role)
        else
          true
        end
      end
    end
  end
end
