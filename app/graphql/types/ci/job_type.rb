# frozen_string_literal: true

module Types
  module Ci
    class JobType < BaseObject
      graphql_name 'CiJob'
      authorize :read_commit_status

      connection_type_class(Types::CountableConnectionType)

      expose_permissions Types::PermissionTypes::Ci::Job

      field :id, ::Types::GlobalIDType[::CommitStatus].as('JobID'), null: true,
            description: 'ID of the job.'
      field :pipeline, Types::Ci::PipelineType, null: true,
            description: 'Pipeline the job belongs to.'
      field :name, GraphQL::STRING_TYPE, null: true,
            description: 'Name of the job.'
      field :needs, BuildNeedType.connection_type, null: true,
            description: 'References to builds that must complete before the jobs run.'
      field :status,
            type: ::Types::Ci::JobStatusEnum,
            null: true,
            description: "Status of the job."
      field :stage, Types::Ci::StageType, null: true,
            description: 'Stage of the job.'
      field :allow_failure, ::GraphQL::BOOLEAN_TYPE, null: false,
            description: 'Whether the job is allowed to fail.'
      field :duration, GraphQL::INT_TYPE, null: true,
            description: 'Duration of the job in seconds.'
      field :tags, [GraphQL::STRING_TYPE], null: true,
            description: 'Tags for the current job.'

      # Life-cycle timestamps:
      field :created_at, Types::TimeType, null: false,
            description: "When the job was created."
      field :queued_at, Types::TimeType, null: true,
            description: 'When the job was enqueued and marked as pending.'
      field :started_at, Types::TimeType, null: true,
            description: 'When the job was started.'
      field :finished_at, Types::TimeType, null: true,
            description: 'When a job has finished running.'
      field :scheduled_at, Types::TimeType, null: true,
            description: 'Schedule for the build.'

      # Life-cycle durations:
      field :queued_duration,
            type: Types::DurationType,
            null: true,
            description: 'How long the job was enqueued before starting.'

      field :detailed_status, Types::Ci::DetailedStatusType, null: true,
            description: 'Detailed status of the job.'
      field :artifacts, Types::Ci::JobArtifactType.connection_type, null: true,
            description: 'Artifacts generated by the job.'
      field :short_sha, type: GraphQL::STRING_TYPE, null: false,
            description: 'Short SHA1 ID of the commit.'
      field :scheduling_type, GraphQL::STRING_TYPE, null: true,
            description: 'Type of pipeline scheduling. Value is `dag` if the pipeline uses the `needs` keyword, and `stage` otherwise.'
      field :commit_path, GraphQL::STRING_TYPE, null: true,
            description: 'Path to the commit that triggered the job.'
      field :ref_name, GraphQL::STRING_TYPE, null: true,
            description: 'Ref name of the job.'
      field :ref_path, GraphQL::STRING_TYPE, null: true,
            description: 'Path to the ref.'
      field :playable, GraphQL::BOOLEAN_TYPE, null: false, method: :playable?,
            description: 'Indicates the job can be played.'
      field :retryable, GraphQL::BOOLEAN_TYPE, null: false, method: :retryable?,
            description: 'Indicates the job can be retried.'
      field :cancelable, GraphQL::BOOLEAN_TYPE, null: false, method: :cancelable?,
            description: 'Indicates the job can be canceled.'
      field :active, GraphQL::BOOLEAN_TYPE, null: false, method: :active?,
            description: 'Indicates the job is active.'
      field :stuck, GraphQL::BOOLEAN_TYPE, null: false, method: :stuck?,
            description: 'Indicates the job is stuck.'
      field :coverage, GraphQL::FLOAT_TYPE, null: true,
            description: 'Coverage level of the job.'
      field :created_by_tag, GraphQL::BOOLEAN_TYPE, null: false,
            description: 'Whether the job was created by a tag.'
      field :manual_job, GraphQL::BOOLEAN_TYPE, null: true,
            description: 'Whether the job has a manual action.'
      field :triggered, GraphQL::BOOLEAN_TYPE, null: true,
            description: 'Whether the job was triggered.'

      def pipeline
        Gitlab::Graphql::Loaders::BatchModelLoader.new(::Ci::Pipeline, object.pipeline_id).find
      end

      def tags
        object.tags.map(&:name) if object.is_a?(::Ci::Build)
      end

      def detailed_status
        object.detailed_status(context[:current_user])
      end

      def artifacts
        if object.is_a?(::Ci::Build)
          object.job_artifacts
        end
      end

      def stage
        ::Gitlab::Graphql::Lazy.with_value(pipeline) do |pl|
          BatchLoader::GraphQL.for([pl, object.stage]).batch do |ids, loader|
            by_pipeline = ids
              .group_by(&:first)
              .transform_values { |grp| grp.map(&:second) }

            by_pipeline.each do |p, names|
              p.stages.by_name(names).each { |s| loader.call([p, s.name], s) }
            end
          end
        end
      end

      # This class is a secret union!
      # TODO: turn this into an actual union, so that fields can be referenced safely!
      def id
        return unless object.id.present?

        model_name = object.type || ::CommitStatus.name
        id = object.id
        Gitlab::GlobalId.build(model_name: model_name, id: id)
      end

      def commit_path
        ::Gitlab::Routing.url_helpers.project_commit_path(object.project, object.sha)
      end

      def ref_name
        object&.ref
      end

      def ref_path
        ::Gitlab::Routing.url_helpers.project_commits_path(object.project, ref_name)
      end

      def coverage
        object&.coverage
      end

      def created_by_tag
        object.tag?
      end

      def manual_job
        object.try(:action?)
      end

      def triggered
        object.try(:trigger_request)
      end
    end
  end
end