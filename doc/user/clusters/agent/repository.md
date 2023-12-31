---
stage: Configure
group: Configure
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Kubernetes Agent configuration repository **(PREMIUM)**

> - [Introduced](https://gitlab.com/gitlab-org/gitlab/-/issues/259669) in [GitLab Premium](https://about.gitlab.com/pricing/) 13.7.
> - [Introduced](https://gitlab.com/groups/gitlab-org/-/epics/3834) in GitLab 13.11, the Kubernetes Agent became available on GitLab.com.

WARNING:
This feature might not be available to you. Check the **version history** note above for details.

The [GitLab Kubernetes Agent integration](index.md) supports hosting your configuration for
multiple GitLab Kubernetes Agents in a single repository. These agents can be running
in the same cluster or in multiple clusters, and potentially with more than one Agent per cluster.

The Agent bootstraps with the GitLab installation URL and an authentication token,
and you provide the rest of the configuration in your repository, following
Infrastructure as Code (IaaC) best practices.

A minimal repository layout looks like this, with `my_agent_1` as the name
of your Agent:

```plaintext
|- .gitlab
    |- agents
       |- my_agent_1
          |- config.yaml
```

## Synchronize manifest projects

Your `config.yaml` file contains a `gitops` section, which contains a `manifest_projects`
section. Each `id` in the `manifest_projects` section is the path to a Git repository
with Kubernetes resource definitions in YAML or JSON format. The Agent monitors
each project you declare, and when the project changes, GitLab deploys the changes
using the Agent.

To use multiple YAML files, specify a `paths` attribute in the `gitops` section.

By default, the Agent monitors all
[Kubernetes object types](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields).
You can exclude some types of resources from monitoring. This enables you to reduce
the permissions needed by the GitOps feature, through `resource_exclusions`.

To enable a specific named resource, first use `resource_inclusions` to enable desired resources.
The following file excerpt includes specific `api_groups` and `kinds`. The `resource_exclusions`
which follow excludes all other `api_groups` and `kinds`:

```yaml
gitops:
  # Manifest projects are watched by the agent. Whenever a project changes,
  # GitLab deploys the changes using the agent.
  manifest_projects:
    # No authentication mechanisms are currently supported.
    # The `id` is a path to a Git repository with Kubernetes resource definitions
    # in YAML or JSON format.
  - id: gitlab-org/cluster-integration/gitlab-agent
    # Holds the only API groups and kinds of resources that gitops will monitor.
    # Inclusion rules are evaluated first, then exclusion rules.
    # If there is still no match, resource is monitored.
    # Resources: https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields
    # Groups: https://kubernetes.io/docs/concepts/overview/kubernetes-api/#api-groups-and-versioning
    resource_inclusions:
    - api_groups:
      - apps
      kinds:
      - '*'
    - api_groups:
      - ''
      kinds:
      - 'ConfigMap'
    # Holds the API groups and kinds of resources to exclude from gitops watch.
    # Inclusion rules are evaluated first, then exclusion rules.
    # If there is still no match, resource is monitored.
    resource_exclusions:
    - api_groups:
      - '*'
      kinds:
      - '*'
    # Namespace to use if not set explicitly in object manifest.
    default_namespace: my-ns
    # Paths inside of the repository to scan for manifest files.
    # Directories with names starting with a dot are ignored.
    paths:
      # Read all .yaml files from team1/app1 directory.
      # See https://github.com/bmatcuk/doublestar#about and
      # https://pkg.go.dev/github.com/bmatcuk/doublestar/v2#Match for globbing rules.
    - glob: '/team1/app1/*.yaml'
      # Read all .yaml files from team2/apps and all subdirectories
    - glob: '/team2/apps/**/*.yaml'
      # If 'paths' is not specified or is an empty list, the configuration below is used
    - glob: '/**/*.{yaml,yml,json}'
```

## Surface network security alerts from cluster to GitLab

The GitLab Agent provides an [integration with Cilium](index.md#kubernetes-network-security-alerts).
To integrate, add a top-level `cilium` section to your `config.yml` file. Currently, the
only configuration option is the Hubble relay address:

```yaml
cilium:
  hubble_relay_address: "<hubble-relay-host>:<hubble-relay-port>"
```

If your Cilium integration was performed through GitLab Managed Apps, you can use `hubble-relay.gitlab-managed-apps.svc.cluster.local:80` as the address:

```yaml
cilium:
  hubble_relay_address: "hubble-relay.gitlab-managed-apps.svc.cluster.local:80"
```

## Debugging

To debug the cluster-side component (`agentk`) of the GitLab Kubernetes Agent, set the log
level according to the available options:

- `off`
- `warning`
- `error`
- `info`
- `debug`

The log level defaults to `info`. You can change it by using a top-level `observability`
section in the configuration file, for example:

```yaml
observability:
  logging:
    level: debug
```
