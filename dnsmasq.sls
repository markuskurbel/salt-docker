dnsmasq:
  pkg.installed: []
  file.managed:
    - name: /etc/dnsmasq.conf
    - user: root
    - group: root
    - mode: 644
    - contents:
      # Explicitly bind dnsmasq to the docker0 interface
      # upstream DNS servers from /etc/resolv.conf will be used
      - "bind-interfaces"
      - "interface=docker0"
      - "listen-address=172.17.0.1"
      # Do not load /etc/hosts
      - "no-hosts"
  service.running:
    - enable: true
    - watch:
      - pkg: dnsmasq
      - file: /etc/dnsmasq.conf

# It's necessary to start dnsmasq after Docker, so the docker0 interface is present.
# Otherwise, we'd get the following errors upon boot:
#
# dnsmasq: failed to create listening socket for 172.17.0.1: Cannot assign requested address
# dnsmasq: unknown interface docker0
/lib/systemd/system/dnsmasq.service:
  file.line:
    - mode: ensure
    - after: {{ '[Unit]' | regex_escape }}
    - content: After=docker.service
