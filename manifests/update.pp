define dotfiles::update(
  $gituser,
  $homedir,
  $cwd,
  $single_pull = false,
  $rebase      = true,
  ) {

  if (!$single_pull) {
    exec { "update ${gituser} dotfiles for ${title}":
      cwd     => "${cwd}",
      command => $rebase ? {true  => "git pull --rebase", false => "git pull", },
      user    => "${title}",
      require => Package['git'],
    }
  }

}
