# frozen_string_literal: true

FactoryBot.define do
  factory :clusters_applications_helm, class: 'Clusters::Applications::Helm' do
    cluster factory: %i(cluster provided_by_gcp)

    transient do
      helm_installed { true }
    end

    before(:create) do |_record, evaluator|
      if evaluator.helm_installed
        allow(Gitlab::Kubernetes::Helm::V2::Certificate).to receive(:generate_root)
          .and_return(
            double(
              key_string: File.read(Rails.root.join('spec/fixtures/clusters/sample_key.key')),
              cert_string: File.read(Rails.root.join('spec/fixtures/clusters/sample_cert.pem'))
            )
          )
      end
    end

    after(:create) do |_record, evaluator|
      if evaluator.helm_installed
        allow(Gitlab::Kubernetes::Helm::V2::Certificate).to receive(:generate_root).and_call_original
      end
    end

    trait :not_installable do
      status { -2 }
    end

    trait :errored do
      status { -1 }
      status_reason { 'something went wrong' }
    end

    trait :installable do
      status { 0 }
    end

    trait :scheduled do
      status { 1 }
    end

    trait :installing do
      status { 2 }
    end

    trait :installed do
      status { 3 }
    end

    trait :updating do
      status { 4 }
    end

    trait :updated do
      status { 5 }
    end

    trait :update_errored do
      status { 6 }
      status_reason { 'something went wrong' }
    end

    trait :uninstalling do
      status { 7 }
    end

    trait :uninstall_errored do
      status { 8 }
      status_reason { 'something went wrong' }
    end

    trait :uninstalled do
      status { 10 }
    end

    trait :externally_installed do
      status { 11 }
    end

    trait :timed_out do
      installing
      updated_at { ClusterWaitForAppInstallationWorker::TIMEOUT.ago }
    end

    # Common trait used by the apps below
    trait :no_helm_installed do
      cluster factory: %i(cluster provided_by_gcp)

      transient do
        helm_installed { false }
      end
    end

    factory :clusters_applications_ingress, class: 'Clusters::Applications::Ingress' do
      modsecurity_enabled { false }
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)

      trait :modsecurity_blocking do
        modsecurity_enabled { true }
        modsecurity_mode { :blocking }
      end

      trait :modsecurity_logging do
        modsecurity_enabled { true }
        modsecurity_mode { :logging }
      end

      trait :modsecurity_disabled do
        modsecurity_enabled { false }
      end

      trait :modsecurity_not_installed do
        modsecurity_enabled { nil }
      end
    end

    factory :clusters_applications_cert_manager, class: 'Clusters::Applications::CertManager' do
      email { 'admin@example.com' }
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_elastic_stack, class: 'Clusters::Applications::ElasticStack' do
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_crossplane, class: 'Clusters::Applications::Crossplane' do
      stack { 'gcp' }
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_prometheus, class: 'Clusters::Applications::Prometheus' do
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_runner, class: 'Clusters::Applications::Runner' do
      runner factory: %i(ci_runner)
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_knative, class: 'Clusters::Applications::Knative' do
      hostname { 'example.com' }
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_jupyter, class: 'Clusters::Applications::Jupyter' do
      oauth_application factory: :oauth_application
      cluster factory: %i(cluster with_installed_helm provided_by_gcp project)
    end

    factory :clusters_applications_fluentd, class: 'Clusters::Applications::Fluentd' do
      host { 'example.com' }
      waf_log_enabled { true }
      cilium_log_enabled { true }
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end

    factory :clusters_applications_cilium, class: 'Clusters::Applications::Cilium' do
      cluster factory: %i(cluster with_installed_helm provided_by_gcp)
    end
  end
end
