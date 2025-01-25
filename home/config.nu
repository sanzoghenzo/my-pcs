# starts zellij on nushell activation, but not inside vscode
def start_zellij [] {
  if "ZELLIJ" in $env or $env.TERM_PROGRAM? == "vscode" {
    return
  }

  if $env.ZELLIJ_AUTO_ATTACH? == "true" {
    zellij attach -c
  } else {
    zellij
  }

  if $env.ZELLIJ_AUTO_EXIT? == "true" {
    exit
  }
}

start_zellij
