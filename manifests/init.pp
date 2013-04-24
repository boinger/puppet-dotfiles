define dotfiles (
  $gituser,
  $giturl       = "git://github.com",
  $project      = "dotfiles",
  $dotfiles_dir = 'home',
  $branch       = "master",
  $homedir      = '',
  $clobber      = true,
  $bak_ext      = '.bak',
  $single_pull  = false,
  $rebase       = true,
  $frequency    = 30,
) {

  if $homedir == '' {
    $real_homedir = "/home/${title}"
  } else {
    $real_homedir = $homedir
  }

  $creates = "${real_homedir}/${project}"

  dotfiles::clone {$title:
    gituser => $gituser,
    giturl  => $giturl,
    project => $project,
    branch  => $branch,
    homedir => $real_homedir,
    creates => $creates;
  }

  exec {
    "link ${title} dotfiles":
      cwd      => "${real_homedir}",
      user     => "${title}",
      provider => shell,
      command  => $clobber ? {
        false => "for f in ${creates}/${dotfiles_dir}/.[^.]*; do
                    [ ! -e \${f##*/} ] && 
                    ln -s \$f ./ || true;
                  done",
        true  => "for f in ${creates}/${dotfiles_dir}/.[^.]*; do
                    if [ \"`readlink \${f##*/}`\" != \"`echo \$f`\" ]; then
                     mv \${f##*/} \${f##*/}${bak_ext};
                     ln -fs \$f ./; 
                    else
                      true;
                    fi;
                  done",
        },
      unless   => $clobber ? {
        false => "for f in ${creates}/${dotfiles_dir}/.[^.]* ; do [ -e \${f##*/} ] || exit 1; done", ## Each dotfile must merely exist
        true  => "for f in ${creates}/${dotfiles_dir}/.[^.]* ; do [ \"`readlink \${f##*/}`\" == \"\$f\" ] || exit 1; done", ## Each dotfile must point to the file in the git project
      },
      require  => Dotfiles::Clone["${title}"];
  }

  dotfiles::update { $title:
    gituser     => $gituser,
    homedir     => $real_homedir,
    cwd         => $creates,
    single_pull => $single_pull,
    rebase      => $rebase,
    frequency   => $frequency,
    require     => Dotfiles::Clone["${title}"];
  }

}
