let
  sanzo = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP";
  users = [ sanzo ];

  zora = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtqAa3TTR+zsI1vsxiVWFu0SRwE4YR7My59xHraDaF3";
  discovery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYAMGKshjm30S4czHhN5jsUZxopIkAuPDeLsTEmNDeh";
  holodeck = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9Svaqviz1qcsZtCPWcWdG9DejtecEBdz+KgYjYF54q";
  zora-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHov3C1A2ZKSurkAGgLLLzvkFq1ntabQ0BaVDRQODMuQ";
  systems = [
    zora
    discovery
    zora-vm
  ];

  media-services = [
    zora
    zora-vm
    sanzo
  ];
in
{
  "tailscale.age".publicKeys = users ++ systems;
  "cloudflare-dns-api-token.age".publicKeys = [
    sanzo
    zora
    zora-vm
  ];
  "deluge-auth.age".publicKeys = media-services;
}
