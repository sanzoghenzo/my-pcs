{
  config,
  lib,
  ...
}: let
  cfg = config.webInfra;
  hosts = config.hostInventory;
in {
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53 67];
    };

    services.adguardhome = {
      enable = true;

      # TODO = uncomment once everything is done declaratively
      # mutableSettings = false;
      settings = {
        http = {
          pprof.enabled = false;
          address = "127.0.0.1:3000";
          session_ttl = "720h";
        };
        users = [
          {
            name = "sanzo";
            password = "$2a$10$/To9vMcq9QBtepHS4MZnKOnHFaJsJXYeg0i/JizBl6SUppd5ZNYCC";
          }
        ];
        auth_attempts = 5;
        block_auth_min = 15;
        http_proxy = "";
        language = "";
        theme = "auto";
        dns = {
          bind_hosts = ["0.0.0.0"];
          port = 53;
          anonymize_client_ip = false;
          ratelimit_whitelist = [];
          refuse_any = true;
          upstream_dns = [
            "https://1.1.1.1/dns-query"
            "https://1.0.0.1/dns-query"
          ];
          upstream_dns_file = "";
          bootstrap_dns = [
            "9.9.9.10"
            "149.112.112.10"
            # "2620:fe::10"
            # "2620:fe::fe:10"
          ];
          fallback_dns = [];
          upstream_mode = "load_balance";
          fastest_timeout = "1s";
          allowed_clients = [];
          disallowed_clients = [];
          blocked_hosts = [
            "version.bind"
            "id.server"
            "hostname.bind"
          ];
          trusted_proxies = [
            "127.0.0.0/8"
            # "::1/128"
          ];
          cache_size = 4194304;
          cache_ttl_min = 0;
          cache_ttl_max = 0;
          cache_optimistic = false;
          bogus_nxdomain = [];
          aaaa_disabled = true;
          enable_dnssec = false;
          edns_client_subnet = {
            custom_ip = "";
            enabled = false;
            use_custom = false;
          };
          max_goroutines = 300;
          handle_ddr = true;
          ipset = [];
          ipset_file = "";
          bootstrap_prefer_ipv6 = false;
          upstream_timeout = "10s";
          private_networks = [];
          use_private_ptr_resolvers = true;
          local_ptr_upstreams = [];
          use_dns64 = false;
          dns64_prefixes = [];
          serve_http3 = false;
          use_http3_upstreams = false;
          serve_plain_dns = true;
          hostsfile_enabled = true;
        };
        tls = {
          enabled = false;
          server_name = "";
          force_https = false;
          port_https = 443;
          port_dns_over_tls = 853;
          port_dns_over_quic = 853;
          port_dnscrypt = 0;
          dnscrypt_config_file = "";
          allow_unencrypted_doh = false;
          certificate_chain = "";
          private_key = "";
          certificate_path = "";
          private_key_path = "";
          strict_sni_check = false;
        };
        querylog = {
          dir_path = "";
          ignored = [];
          interval = "2160h";
          size_memory = 1000;
          enabled = true;
          file_enabled = true;
        };
        statistics = {
          dir_path = "";
          ignored = [];
          interval = "24h";
          enabled = true;
        };
        filters = [
          {
            enabled = true;
            url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
            name = "Hagezi Multi PRO";
            id = 1;
          }
          {
            enabled = true;
            url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt";
            name = "Hagezi Threat Intelligence Feeds";
            id = 2;
          }
          {
            enabled = true;
            url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/gambling.txt";
            name = "Hagezi Gambling";
            id = 3;
          }
          {
            enabled = false;
            url = "https://nsfw.oisd.nl/";
            name = "OISD NSFW (Shock/Porn/Adult)";
            id = 4;
          }
        ];
        whitelist_filters = [];
        user_rules = [];
        dhcp = {
          enabled = true;
          interface_name = "eth0";
          local_domain_name = "sanzoghenzo.lan";
          dhcpv4 = {
            gateway_ip = hosts.modem.ipAddress;
            subnet_mask = "255.255.255.0";
            range_start = "192.168.1.60";
            range_end = "192.168.1.210";
            lease_duration = 86400;
            icmp_timeout_msec = 1000;
            options = [
              "15 text sanzoghenzo.lan"
              "119 text sanzoghenzo.lan"
            ];
          };
          dhcpv6 = {
            range_start = "";
            lease_duration = 86400;
            ra_slaac_only = true;
            ra_allow_slaac = false;
          };
        };
        filtering = {
          blocking_ipv4 = "";
          blocking_ipv6 = "";
          blocked_services = {
            schedule = {
              time_zone = "Local";
            };
            ids = [];
          };
          protection_disabled_until = null;
          safe_search = {
            enabled = false;
            bing = true;
            duckduckgo = true;
            google = true;
            pixabay = true;
            yandex = true;
            youtube = true;
          };
          blocking_mode = "default";
          parental_block_host = "family-block.dns.adguard.com";
          safebrowsing_block_host = "standard-block.dns.adguard.com";
          safebrowsing_cache_size = 1048576;
          safesearch_cache_size = 1048576;
          parental_cache_size = 1048576;
          cache_time = 30;
          filters_update_interval = 24;
          blocked_response_ttl = 10;
          filtering_enabled = true;
          parental_enabled = false;
          safebrowsing_enabled = false;
          protection_enabled = true;
        };
        clients = {
          runtime_sources = {
            whois = true;
            arp = true;
            rdns = true;
            dhcp = true;
            hosts = true;
          };
          persistent = [];
        };
        log = {
          enabled = true;
          file = "";
          max_backups = 0;
          max_size = 100;
          max_age = 3;
          compress = false;
          local_time = false;
          verbose = false;
        };
        os = {
          group = "";
          user = "";
          rlimit_nofile = 0;
        };
        schema_version = 28;
      };
    };
    proxiedServices.dns = {
      port = config.services.adguardhome.port;
      cert = "staging";
    };

    # TODO: dhcp leases are defined in /var/lib/AdGuardHome/data/leases.json
    # "The file format is not stable and may change in the future releases"
  };
}
