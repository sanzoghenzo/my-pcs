# zellij
def start_zellij [] {
  if 'ZELLIJ' not-in $env {
    if $env.ZELLIJ_AUTO_ATTACH? == 'true' {
      zellij attach -c
    } else {
      zellij
    }

    if $env.ZELLIJ_AUTO_EXIT? == 'true' {
      exit
    }
  }
}

start_zellij
