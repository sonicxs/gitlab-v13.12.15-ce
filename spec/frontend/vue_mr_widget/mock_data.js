import { SUCCESS } from '~/vue_merge_request_widget/components/deployment/constants';

export const artifacts = [
  {
    text: 'result.txt',
    url: 'bar',
    job_name: 'generate-artifact',
    job_path: 'bar',
  },
  {
    text: 'foo.txt',
    url: 'foo',
    job_name: 'foo-artifact',
    job_path: 'foo',
  },
];

export default {
  id: 132,
  iid: 22,
  assignee_id: null,
  author_id: 1,
  description: '',
  lock_version: null,
  milestone_id: null,
  position: 0,
  state: 'merged',
  title: 'Update README.md',
  updated_by_id: null,
  created_at: '2017-04-07T12:27:26.718Z',
  updated_at: '2017-04-07T15:39:25.852Z',
  time_estimate: 0,
  total_time_spent: 0,
  human_access: 'Maintainer',
  human_time_estimate: null,
  human_total_time_spent: null,
  in_progress_merge_commit_sha: null,
  merge_commit_sha: '53027d060246c8f47e4a9310fb332aa52f221775',
  short_merge_commit_sha: '53027d06',
  merge_error: null,
  merge_params: {
    force_remove_source_branch: null,
  },
  merge_status: 'can_be_merged',
  merge_user_id: null,
  pipelines_empty_svg_path: '/path/to/svg',
  source_branch: 'daaaa',
  source_branch_link: 'daaaa',
  source_project_id: 19,
  source_project_full_path: '/group1/project1',
  target_branch: 'main',
  target_project_id: 19,
  target_project_full_path: '/group2/project2',
  merge_request_add_ci_config_path: '/group2/project2/new/pipeline',
  is_dismissed_suggest_pipeline: false,
  user_callouts_path: 'some/callout/path',
  suggest_pipeline_feature_id: 'suggest_pipeline',
  new_project_pipeline_path: '/group2/project2/pipelines/new',
  source_project_default_url: '/gitlab-org/html5-boilerplate.git',
  metrics: {
    merged_by: {
      name: 'Administrator',
      username: 'root',
      id: 1,
      state: 'active',
      avatar_url:
        'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
      web_url: 'http://localhost:3000/root',
    },
    merged_at: '2017-04-07T15:39:25.696Z',
    closed_by: null,
    closed_at: null,
  },
  author: {
    name: 'Administrator',
    username: 'root',
    id: 1,
    state: 'active',
    avatar_url: 'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
    web_url: 'http://localhost:3000/root',
  },
  merge_user: null,
  diff_head_sha: '104096c51715e12e7ae41f9333e9fa35b73f385d',
  diff_head_commit_short_id: '104096c5',
  default_merge_commit_message:
    "Merge branch 'daaaa' into 'main'\n\nUpdate README.md\n\nSee merge request !22",
  pipeline: {
    id: 172,
    user: {
      name: 'Administrator',
      username: 'root',
      id: 1,
      state: 'active',
      avatar_url:
        'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
      web_url: 'http://localhost:3000/root',
    },
    active: false,
    coverage: '92.16',
    path: '/root/acets-app/pipelines/172',
    details: {
      artifacts,
      status: {
        icon: 'status_success',
        favicon: 'favicon_status_success',
        text: 'passed',
        label: 'passed',
        group: 'success',
        has_details: true,
        details_path: '/root/acets-app/pipelines/172',
      },
      duration: null,
      finished_at: '2017-04-07T14:00:14.256Z',
      stages: [
        {
          name: 'build',
          title: 'build: failed',
          status: {
            icon: 'status_failed',
            favicon: 'favicon_status_failed',
            text: 'failed',
            label: 'failed',
            group: 'failed',
            has_details: true,
            details_path: '/root/acets-app/pipelines/172#build',
          },
          path: '/root/acets-app/pipelines/172#build',
          dropdown_path: '/root/acets-app/pipelines/172/stage.json?stage=build',
        },
        {
          name: 'review',
          title: 'review: skipped',
          status: {
            icon: 'status_skipped',
            favicon: 'favicon_status_skipped',
            text: 'skipped',
            label: 'skipped',
            group: 'skipped',
            has_details: true,
            details_path: '/root/acets-app/pipelines/172#review',
          },
          path: '/root/acets-app/pipelines/172#review',
          dropdown_path: '/root/acets-app/pipelines/172/stage.json?stage=review',
        },
      ],
      manual_actions: [
        {
          name: 'stop_review',
          path: '/root/acets-app/builds/1427/play',
          playable: false,
        },
      ],
    },
    flags: {
      latest: false,
      triggered: false,
      stuck: false,
      yaml_errors: false,
      retryable: true,
      cancelable: false,
      merge_request_pipeline: false,
      detached_merge_request_pipeline: true,
    },
    ref: {
      name: 'daaaa',
      path: '/root/acets-app/tree/daaaa',
      tag: false,
      branch: true,
    },
    merge_request: {
      iid: 1,
      path: '/root/detached-merge-request-pipelines/-/merge_requests/1',
      title: 'Update README.md',
      source_branch: 'feature-1',
      source_branch_path: '/root/detached-merge-request-pipelines/branches/feature-1',
      target_branch: 'main',
      target_branch_path: '/root/detached-merge-request-pipelines/branches/main',
    },
    commit: {
      id: '104096c51715e12e7ae41f9333e9fa35b73f385d',
      short_id: '104096c5',
      title: 'Update README.md',
      created_at: '2017-04-07T15:27:18.000+03:00',
      parent_ids: ['2396536178668d8930c29d904e53bd4d06228b32'],
      message: 'Update README.md',
      author_name: 'Administrator',
      author_email: 'admin@example.com',
      authored_date: '2017-04-07T15:27:18.000+03:00',
      committer_name: 'Administrator',
      committer_email: 'admin@example.com',
      committed_date: '2017-04-07T15:27:18.000+03:00',
      author: {
        name: 'Administrator',
        username: 'root',
        id: 1,
        state: 'active',
        avatar_url:
          'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
        web_url: 'http://localhost:3000/root',
      },
      author_gravatar_url:
        'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
      commit_url:
        'http://localhost:3000/root/acets-app/commit/104096c51715e12e7ae41f9333e9fa35b73f385d',
      commit_path: '/root/acets-app/commit/104096c51715e12e7ae41f9333e9fa35b73f385d',
    },
    retry_path: '/root/acets-app/pipelines/172/retry',
    created_at: '2017-04-07T12:27:19.520Z',
    updated_at: '2017-04-07T15:28:44.800Z',
  },
  pipelineCoverageDelta: '15.25',
  buildsWithCoverage: [
    { name: 'karma', coverage: '40.2' },
    { name: 'rspec', coverage: '80.4' },
  ],
  work_in_progress: false,
  source_branch_exists: false,
  mergeable_discussions_state: true,
  conflicts_can_be_resolved_in_ui: false,
  branch_missing: true,
  commits_count: 1,
  has_conflicts: false,
  can_be_merged: true,
  has_ci: true,
  ci_status: 'success',
  pipeline_status_path: '/root/acets-app/-/merge_requests/22/pipeline_status',
  issues_links: {
    closing: '',
    mentioned_but_not_closing: '',
  },
  current_user: {
    can_resolve_conflicts: true,
    can_remove_source_branch: false,
    can_revert_on_current_merge_request: true,
    can_cherry_pick_on_current_merge_request: true,
  },
  codeclimate: {
    head_path: 'head.json',
    base_path: 'base.json',
  },
  blob_path: {
    base_path: 'blob_path',
    head_path: 'blob_path',
  },
  codequality_help_path: 'code_quality.html',
  target_branch_path: '/root/acets-app/branches/main',
  source_branch_path: '/root/acets-app/branches/daaaa',
  conflict_resolution_ui_path: '/root/acets-app/-/merge_requests/22/conflicts',
  remove_wip_path: '/root/acets-app/-/merge_requests/22/remove_wip',
  cancel_auto_merge_path: '/root/acets-app/-/merge_requests/22/cancel_auto_merge',
  create_issue_to_resolve_discussions_path:
    '/root/acets-app/-/issues/new?merge_request_to_resolve_discussions_of=22',
  merge_path: '/root/acets-app/-/merge_requests/22/merge',
  cherry_pick_in_fork_path:
    '/root/acets-app/forks?continue%5Bnotice%5D=You%27re+not+allowed+to+make+changes+to+this+project+directly.+A+fork+of+this+project+has+been+created+that+you+can+make+changes+in%2C+so+you+can+submit+a+merge+request.+Try+to+revert+this+commit+again.&continue%5Bnotice_now%5D=You%27re+not+allowed+to+make+changes+to+this+project+directly.+A+fork+of+this+project+is+being+created+that+you+can+make+changes+in%2C+so+you+can+submit+a+merge+request.&continue%5Bto%5D=%2Froot%2Facets-app%2Fmerge_requests%2F22&namespace_key=1',
  revert_in_fork_path:
    '/root/acets-app/forks?continue%5Bnotice%5D=You%27re+not+allowed+to+make+changes+to+this+project+directly.+A+fork+of+this+project+has+been+created+that+you+can+make+changes+in%2C+so+you+can+submit+a+merge+request.+Try+to+cherry-pick+this+commit+again.&continue%5Bnotice_now%5D=You%27re+not+allowed+to+make+changes+to+this+project+directly.+A+fork+of+this+project+is+being+created+that+you+can+make+changes+in%2C+so+you+can+submit+a+merge+request.&continue%5Bto%5D=%2Froot%2Facets-app%2Fmerge_requests%2F22&namespace_key=1',
  email_patches_path: '/root/acets-app/-/merge_requests/22.patch',
  plain_diff_path: '/root/acets-app/-/merge_requests/22.diff',
  merge_request_basic_path: '/root/acets-app/-/merge_requests/22.json?serializer=basic',
  merge_request_widget_path: '/root/acets-app/-/merge_requests/22/widget.json',
  merge_request_cached_widget_path: '/cached.json',
  merge_check_path: '/root/acets-app/-/merge_requests/22/merge_check',
  ci_environments_status_url: '/root/acets-app/-/merge_requests/22/ci_environments_status',
  project_archived: false,
  default_merge_commit_message_with_description:
    "Merge branch 'daaaa' into 'main'\n\nUpdate README.md\n\nSee merge request !22",
  default_squash_commit_message: 'Test squash commit message',
  diverged_commits_count: 0,
  only_allow_merge_if_pipeline_succeeds: false,
  commit_change_content_path: '/root/acets-app/-/merge_requests/22/commit_change_content',
  merge_commit_path:
    'http://localhost:3000/root/acets-app/commit/53027d060246c8f47e4a9310fb332aa52f221775',
  mr_troubleshooting_docs_path: 'help',
  ci_troubleshooting_docs_path: 'help2',
  merge_request_pipelines_docs_path: '/help/ci/merge_request_pipelines/index.md',
  merge_train_when_pipeline_succeeds_docs_path:
    '/help/ci/merge_request_pipelines/pipelines_for_merged_results/merge_trains/#startadd-to-merge-train-when-pipeline-succeeds',
  squash: true,
  visual_review_app_available: true,
  merge_trains_enabled: true,
  merge_trains_count: 3,
  merge_train_index: 1,
  security_reports_docs_path: 'security-reports-docs-path',
  sast_comparison_path: '/sast_comparison_path',
  secret_scanning_comparison_path: '/secret_scanning_comparison_path',
};

export const mockStore = {
  pipeline: {
    id: 0,
    details: {
      artifacts,
      status: {
        details_path: '/root/review-app-tester/pipelines/66',
        favicon:
          '/assets/ci_favicons/favicon_status_success-8451333011eee8ce9f2ab25dc487fe24a8758c694827a582f17f42b0a90446a2. png',
        group: 'success-with-warnings',
        has_details: true,
        icon: 'status_warning',
        illustration: null,
        label: 'passed with warnings',
        text: 'passed',
        tooltip: 'passed',
      },
    },
    flags: {},
    ref: {},
  },
  mergePipeline: {
    id: 1,
    details: {
      artifacts,
      status: {
        details_path: '/root/review-app-tester/pipelines/66',
        favicon:
          '/assets/ci_favicons/favicon_status_success-8451333011eee8ce9f2ab25dc487fe24a8758c694827a582f17f42b0a90446a2. png',
        group: 'success-with-warnings',
        has_details: true,
        icon: 'status_warning',
        illustration: null,
        label: 'passed with warnings',
        text: 'passed',
        tooltip: 'passed',
      },
    },
    flags: {},
    ref: {},
  },
  targetBranch: 'target-branch',
  sourceBranch: 'source-branch',
  sourceBranchLink: 'source-branch-link',
  deployments: [
    {
      id: 0,
      name: 'bogus',
      external_url: 'https://fake.com',
      external_url_formatted: 'https://fake.com',
      status: SUCCESS,
    },
    {
      id: 1,
      name: 'bogus-docs',
      external_url: 'https://fake.com',
      external_url_formatted: 'https://fake.com',
      status: SUCCESS,
    },
  ],
  postMergeDeployments: [
    { id: 0, name: 'prod', status: SUCCESS },
    { id: 1, name: 'prod-docs', status: SUCCESS },
  ],
  mrTroubleshootingDocsPath: 'mr-troubleshooting-docs-path',
  ciTroubleshootingDocsPath: 'ci-troubleshooting-docs-path',
  ciStatus: 'ci-status',
  hasCI: true,
  exposedArtifactsPath: 'exposed_artifacts.json',
};