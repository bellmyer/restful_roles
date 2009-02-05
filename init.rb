ActiveRecord::Base.send(:include, Bellmyer::RestfulRoles)
ActionController::Base.send(:include, Bellmyer::RestfulRolesController)
