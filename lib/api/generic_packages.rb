# frozen_string_literal: true

module API
  class GenericPackages < ::API::Base
    GENERIC_PACKAGES_REQUIREMENTS = {
      package_name: API::NO_SLASH_URL_PART_REGEX,
      file_name: API::NO_SLASH_URL_PART_REGEX
    }.freeze

    ALLOWED_STATUSES = %w[default hidden].freeze

    feature_category :package_registry

    before do
      require_packages_enabled!
      authenticate_non_get!

      require_generic_packages_available!
    end

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end

    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      route_setting :authentication, job_token_allowed: true, basic_auth_personal_access_token: true, deploy_token_allowed: true

      namespace ':id/packages/generic' do
        namespace ':package_name/*package_version/:file_name', requirements: GENERIC_PACKAGES_REQUIREMENTS do
          desc 'Workhorse authorize generic package file' do
            detail 'This feature was introduced in GitLab 13.5'
          end

          route_setting :authentication, job_token_allowed: true, basic_auth_personal_access_token: true, deploy_token_allowed: true

          params do
            requires :package_name, type: String, desc: 'Package name', regexp: Gitlab::Regex.generic_package_name_regex, file_path: true
            requires :package_version, type: String, desc: 'Package version', regexp: Gitlab::Regex.generic_package_version_regex
            requires :file_name, type: String, desc: 'Package file name', regexp: Gitlab::Regex.generic_package_file_name_regex, file_path: true
            optional :status, type: String, values: ALLOWED_STATUSES, desc: 'Package status'
          end

          put 'authorize' do
            authorize_workhorse!(subject: project, maximum_size: project.actual_limits.generic_packages_max_file_size)
          end

          desc 'Upload package file' do
            detail 'This feature was introduced in GitLab 13.5'
          end

          params do
            requires :package_name, type: String, desc: 'Package name', regexp: Gitlab::Regex.generic_package_name_regex, file_path: true
            requires :package_version, type: String, desc: 'Package version', regexp: Gitlab::Regex.generic_package_version_regex
            requires :file_name, type: String, desc: 'Package file name', regexp: Gitlab::Regex.generic_package_file_name_regex, file_path: true
            optional :status, type: String, values: ALLOWED_STATUSES, desc: 'Package status'
            requires :file, type: ::API::Validations::Types::WorkhorseFile, desc: 'The package file to be published (generated by Multipart middleware)'
          end

          route_setting :authentication, job_token_allowed: true, basic_auth_personal_access_token: true, deploy_token_allowed: true

          put do
            authorize_upload!(project)
            bad_request!('File is too large') if max_file_size_exceeded?

            ::Gitlab::Tracking.event(self.options[:for].name, 'push_package')

            create_package_file_params = declared_params.merge(build: current_authenticated_job)
            ::Packages::Generic::CreatePackageFileService
              .new(project, current_user, create_package_file_params)
              .execute

            created!
          rescue ObjectStorage::RemoteStoreError => e
            Gitlab::ErrorTracking.track_exception(e, extra: { file_name: params[:file_name], project_id: project.id })

            forbidden!
          rescue ::Packages::DuplicatePackageError
            bad_request!('Duplicate package is not allowed')
          end

          desc 'Download package file' do
            detail 'This feature was introduced in GitLab 13.5'
          end

          params do
            requires :package_name, type: String, desc: 'Package name', regexp: Gitlab::Regex.generic_package_name_regex, file_path: true
            requires :package_version, type: String, desc: 'Package version', regexp: Gitlab::Regex.generic_package_version_regex
            requires :file_name, type: String, desc: 'Package file name', regexp: Gitlab::Regex.generic_package_file_name_regex, file_path: true
          end

          route_setting :authentication, job_token_allowed: true, basic_auth_personal_access_token: true, deploy_token_allowed: true

          get do
            authorize_read_package!(project)

            package = ::Packages::Generic::PackageFinder.new(project).execute!(params[:package_name], params[:package_version])
            package_file = ::Packages::PackageFileFinder.new(package, params[:file_name]).execute!

            ::Gitlab::Tracking.event(self.options[:for].name, 'pull_package')

            present_carrierwave_file!(package_file.file)
          end
        end
      end
    end

    helpers do
      include ::API::Helpers::PackagesHelpers
      include ::API::Helpers::Packages::BasicAuthHelpers

      def require_generic_packages_available!
        not_found! unless Feature.enabled?(:generic_packages, project, default_enabled: true)
      end

      def project
        authorized_user_project
      end

      def max_file_size_exceeded?
        project.actual_limits.exceeded?(:generic_packages_max_file_size, params[:file].size)
      end
    end
  end
end
