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
        
        if options[:except]
          self.required_roles[:except] = {:role=>required_role, :list=>[]}
          Array(options[:except]).each {|action| self.required_roles[:except][:list] << action.to_sym}
        elsif options[:only]
          self.required_roles[:only] ||= {}
          Array(options[:only]).each {|action| self.required_roles[:only][action.to_sym] = required_role}
        else
          self.required_roles[:all_roles] = required_role
        end
      end
    end
    
    module InstanceMethods
      def authorized?
        required_role = nil
        if self.required_roles[:except]
          required_role = self.required_roles[:except][:role] if !self.required_roles[:except][:list].include?(action_name.to_sym)
        else
          required_role = self.required_roles[:only][action_name.to_sym] || self.required_roles[:all_roles]
        end
                
        if required_role
          current_user && current_user.authorized?(required_role)
        else
          true
        end
      end
    end
  end
end
