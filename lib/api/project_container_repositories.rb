# frozen_string_literal: true

module API
  class ProjectContainerRepositories < ::API::Base
    include PaginationParams
    helpers ::API::Helpers::PackagesHelpers

    REPOSITORY_ENDPOINT_REQUIREMENTS = API::NAMESPACE_OR_PROJECT_REQUIREMENTS.merge(
      tag_name: API::NO_SLASH_URL_PART_REGEX)

    before { authorize_read_container_images! }

    feature_category :package_registry

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end
    route_setting :authentication, job_token_allowed: true, job_token_scope: :project
    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      desc 'Get a project container repositories' do
        detail 'This feature was introduced in GitLab 11.8.'
        success Entities::ContainerRegistry::Repository
      end
      params do
        use :pagination
        optional :tags, type: Boolean, default: false, desc: 'Determines if tags should be included'
        optional :tags_count, type: Boolean, default: false, desc: 'Determines if the tags count should be included'
      end
      get ':id/registry/repositories' do
        repositories = ContainerRepositoriesFinder.new(
          user: current_user, subject: user_project
        ).execute

        track_package_event('list_repositories', :container)

        present paginate(repositories), with: Entities::ContainerRegistry::Repository, tags: params[:tags], tags_count: params[:tags_count]
      end

      desc 'Delete repository' do
        detail 'This feature was introduced in GitLab 11.8.'
      end
      params do
        requires :repository_id, type: Integer, desc: 'The ID of the repository'
      end
      delete ':id/registry/repositories/:repository_id', requirements: REPOSITORY_ENDPOINT_REQUIREMENTS do
        authorize_admin_container_image!

        DeleteContainerRepositoryWorker.perform_async(current_user.id, repository.id) # rubocop:disable CodeReuse/Worker
        track_package_event('delete_repository', :container)

        status :accepted
      end

      desc 'Get a list of repositories tags' do
        detail 'This feature was introduced in GitLab 11.8.'
        success Entities::ContainerRegistry::Tag
      end
      params do
        requires :repository_id, type: Integer, desc: 'The ID of the repository'
        use :pagination
      end
      get ':id/registry/repositories/:repository_id/tags', requirements: REPOSITORY_ENDPOINT_REQUIREMENTS do
        authorize_read_container_image!

        tags = Kaminari.paginate_array(repository.tags)
        track_package_event('list_tags', :container)

        present paginate(tags), with: Entities::ContainerRegistry::Tag
      end

      desc 'Delete repository tags (in bulk)' do
        detail 'This feature was introduced in GitLab 11.8.'
      end
      params do
        requires :repository_id, type: Integer, desc: 'The ID of the repository'
        optional :name_regex_delete, type: String, untrusted_regexp: true, desc: 'The tag name regexp to delete, specify .* to delete all'
        optional :name_regex, type: String, untrusted_regexp: true, desc: 'The tag name regexp to delete, specify .* to delete all'
        # require either name_regex (deprecated) or name_regex_delete, it is ok to have both
        at_least_one_of :name_regex, :name_regex_delete
        optional :name_regex_keep, type: String, untrusted_regexp: true, desc: 'The tag name regexp to retain'
        optional :keep_n, type: Integer, desc: 'Keep n of latest tags with matching name'
        optional :older_than, type: String, desc: 'Delete older than: 1h, 1d, 1month'
      end
      delete ':id/registry/repositories/:repository_id/tags', requirements: REPOSITORY_ENDPOINT_REQUIREMENTS do
        authorize_admin_container_image!

        message = 'This request has already been made. You can run this at most once an hour for a given container repository'
        render_api_error!(message, 400) unless obtain_new_cleanup_container_lease

        # rubocop:disable CodeReuse/Worker
        CleanupContainerRepositoryWorker.perform_async(current_user.id, repository.id,
          declared_params.except(:repository_id).merge(container_expiration_policy: false))
        # rubocop:enable CodeReuse/Worker

        track_package_event('delete_tag_bulk', :container)

        status :accepted
      end

      desc 'Get a details about repository tag' do
        detail 'This feature was introduced in GitLab 11.8.'
        success Entities::ContainerRegistry::TagDetails
      end
      params do
        requires :repository_id, type: Integer, desc: 'The ID of the repository'
        requires :tag_name, type: String, desc: 'The name of the tag'
      end
      get ':id/registry/repositories/:repository_id/tags/:tag_name', requirements: REPOSITORY_ENDPOINT_REQUIREMENTS do
        authorize_read_container_image!
        validate_tag!

        present tag, with: Entities::ContainerRegistry::TagDetails
      end

      desc 'Delete repository tag' do
        detail 'This feature was introduced in GitLab 11.8.'
      end
      params do
        requires :repository_id, type: Integer, desc: 'The ID of the repository'
        requires :tag_name, type: String, desc: 'The name of the tag'
      end
      delete ':id/registry/repositories/:repository_id/tags/:tag_name', requirements: REPOSITORY_ENDPOINT_REQUIREMENTS do
        authorize_destroy_container_image!
        validate_tag!

        result = ::Projects::ContainerRepository::DeleteTagsService
          .new(repository.project, current_user, tags: [declared_params[:tag_name]])
          .execute(repository)

        if result[:status] == :success
          track_package_event('delete_tag', :container)

          status :ok
        else
          status :bad_request
        end
      end
    end

    helpers do
      def authorize_read_container_images!
        authorize! :read_container_image, user_project
      end

      def authorize_read_container_image!
        authorize! :read_container_image, repository
      end

      def authorize_destroy_container_image!
        authorize! :destroy_container_image, repository
      end

      def authorize_admin_container_image!
        authorize! :admin_container_image, repository
      end

      def obtain_new_cleanup_container_lease
        Gitlab::ExclusiveLease
          .new("container_repository:cleanup_tags:#{repository.id}",
               timeout: 1.hour)
          .try_obtain
      end

      def repository
        @repository ||= user_project.container_repositories.find(params[:repository_id])
      end

      def tag
        @tag ||= repository.tag(params[:tag_name])
      end

      def validate_tag!
        not_found!('Tag') unless tag.valid?
      end
    end
  end
end
