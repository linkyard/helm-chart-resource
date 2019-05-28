# helm-chart-resource

A Concourse resource for managing Helm charts.

## Installing

Use this resource by adding the following to the resource_types section of a pipeline config:

```yaml
resource_types:

- name: helm-chart
  type: docker-image
  source:
    repository: linkyard/helm-chart-resource
```

See the [Concourse docs](https://concourse-ci.org/resource-types.html) for more details on adding `resource_types` to a pipeline config.

## Source Configuration

* `chart`: *Required.* Name of chart, with or without repo name
* `repos`: *Optional.* Array of Helm repositories to initialize, each repository is defined as an object with properties name, url (required) username and password (optional).

## Behavior

### `check`: Check for new chart version.

### `in`: Downloads the chart.

Downloads the chart that was discovered during the `check` phase as a tar.

#### Parameters

- `untar`: *Optional.* Extract the tar after downloading. Defaults to `false`.
- `untardir`: *Optional.* Name of the directory that untar will extract to.
- `verify`: *Optional.* Verify the package against its signature. Defaults to `false`.

#### Additional files populated

- `version`: Version of helm chart discovered and downloaded

### `out`: No operation.

## Examples

### In

Checks for version changes on the chart, downloads and untars it:

```yaml
resources:
- name: concourse
  type: helm-chart
  source:
    chart: stable/concourse

jobs:
  # ...
  plan:
  - get: concourse
    trigger: true
    params:
      untar: true
  - task: use-chart
    config:
      platform: linux
      image_resource:
        type: docker-image
        source:
          repository: alpine
      inputs:
      - name: concourse
      run:
        path: cat
        args:
        - "concourse/concourse/Chart.yaml"
```
