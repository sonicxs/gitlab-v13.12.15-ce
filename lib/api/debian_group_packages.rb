# frozen_string_literal: true

module API
  class DebianGroupPackages < ::API::Base
    params do
      requires :id, type: String, desc: 'The ID of a group'
    end

    resource :groups, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      before do
        require_packages_enabled!

        not_found! unless ::Feature.enabled?(:debian_packages, user_group)

        authorize_read_package!(user_group)
      end

      namespace ':id/-' do
        include ::API::Concerns::Packages::DebianEndpoints
      end
    end
  end
end
