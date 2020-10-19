# Usage

## config file ***.pre-commit-config.yaml*** with content:
```bash
$ cat .pre-commit-config.yaml
- repo: https://github.com/voronenko/pre-commit-circleci.git
  rev: master # get latest tag from release tab
  hooks:
    - id: circleci_validate
```
