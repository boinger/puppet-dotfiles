define dotfiles (
  $gituser,
  $giturl       = "git://github.com",
  $project      = "dotfiles",
  $dotfiles_dir = 'home',
  $branch       = "master",
  $homedir      = '',
  $single_pull  = false,
  $rebase       = true,
) {

  if $homedir == '' {
    $real_homedir = "/home/${title}"
  } else {
    $real_homedir = $homedir
  }

  $creates = "${real_homedir}/${project}"

  dotfiles::pull {$title:
    gituser => $gituser,
    giturl  => $giturl,
    project => $project,
    branch  => $branch,
    homedir => $real_homedir,
    creates => $creates;
  }

  exec {
    'link dotfiles':
      cwd      => "${real_homedir}",
      user     => "${title}",
      provider => shell,
      command => "for f in ${creates}/${dotfiles_dir}/.*; do [ -f \$f ] && ln -fs \$f ./ || true; done",
      unless => "i=0; for f in ${creates}/${dotfiles_dir}/.* ; do [ \"\${f##*/}\" == \"..\" ] || [ \"\${f##*/}\" == \".\" ] || [ -h \${f##*/} ] || exit 1; done",
      require  => Dotfiles::Pull["${title}"];
  }

  dotfiles::update {$title:
    gituser     => $gituser,
    homedir     => $real_homedir,
    cwd         => $creates,
    single_pull => $single_pull,
    require     => Dotfiles::Pull["${title}"];
  }

}
