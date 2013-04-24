define dotfiles::update(
  $gituser,
  $homedir,
  $cwd,
  $single_pull,
  $rebase,
  $frequency,
  ) {

  if (!$single_pull) {
    exec { "update ${gituser} dotfiles for ${title}":
      cwd     => "${cwd}",
      command => $rebase ? {true  => "git pull --rebase", false => "git pull", },
      onlyif  => "[ \"$(( ( $(date +%s) - $(stat -c \"%Y\" .git/FETCH_HEAD) ) / 60 ))\" -ge \"${frequency}\" ]",
      user    => "${title}",
      require => Package['git'],
    }
  }

}
