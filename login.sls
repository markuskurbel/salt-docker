# This state can be used to ensure root is authenticated against a set
# of pillar-configured registries, each with their separate set of credentials

include:
  - docker

install_pip_for_custom_python_modules:
  pkg.installed: [python3-pip]

install_python_lib_for_docker_via_pip:
  pip.installed:
    - name: docker
    - require:
      - pkg: python3-pip

authenticate_root_with_docker_registries:
  module.run:
    - docker.login:
    - require:
      - service: docker
