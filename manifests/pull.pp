define dotfiles::pull(
    $gituser,
    $giturl  = "git://github.com",
    $project = "dotfiles",
    $branch  = "master",
    $homedir,
    $creates,
  ) {
  exec { "pull ${gituser} dotfiles for ${title}":
    cwd     => "${homedir}",
    command => "git clone ${giturl}/${gituser}/${project}.git --branch $branch",
    creates => "${creates}",
    user    => "${title}",
    require => Package['git'],
  }
}
