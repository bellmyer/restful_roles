module Bellmyer
  module RestfulRolesController
    def self.included(base)
      base.extend RestfulRolesMethods
    end
    
    module RestfulRolesMethods
      def require_role(required_role, options={})
        unless included_modules.include? InstanceMethods
          class_inheritable_accessor :required_role
          class_inheritable_accessor :options
          
          include InstanceMethods
        end
        
        self.required_role = required_role
        self.options = options
      end
    end
    
    module InstanceMethods
      def authorized?
        if (self.options[:only] && Array(self.options[:only]).map{|o| o.to_sym}.include?(action_name.to_sym)) ||
            (self.options[:except] && !Array(self.options[:except]).map{|o| o.to_sym}.include?(action_name.to_sym)) ||
            (self.options[:only].nil? && self.options[:except].nil?)
          current_user && current_user.authorized?(self.required_role)
        else
          true
        end
      end
    end
  end
end
