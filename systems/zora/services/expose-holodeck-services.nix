{ ... }:
let
  holodeckIp = "192.168.1.240";
in
{
  proxiedServices.home = {
    targetHost = holodeckIp;
    port = 8123;
  };
  proxiedServices.containers = {
    targetHost = holodeckIp;
    port = 9000;
  };
  proxiedServices.grafana = {
    targetHost = holodeckIp;
    port = 3000;
  };
  proxiedServices.appdaemon = {
    targetHost = holodeckIp;
    port = 5050;
  };
}
