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
      command  => $clobber ? {
        false => "for f in ${creates}/${dotfiles_dir}/.*; do [ \"\${f##*/}\" != \"..\" ] && [ \"\${f##*/}\" != \".\" ] &&
                  [ ! -e \${f##*/} ] && 
                  ln -fs \$f ./ || true;
                  done",
        true  => "for f in ${creates}/${dotfiles_dir}/.*; do [ -f \$f ] &&
                  if [ \"`readlink \${f##*/}`\" != \"`echo \$f`\" ]; then
                   mv \${f##*/} \${f##*/}${bak_ext};
                   ln -fs \$f ./; 
                  else
                    true;
                  fi;
                  done",
        },
      #command  => "for f in ${creates}/${dotfiles_dir}/.*; do [ -f \$f ] && ln -fs \$f ./ || true; done",
      unless   => $clobber ? {
        false => "for f in ${creates}/${dotfiles_dir}/.* ; do [ \"\${f##*/}\" == \"..\" ] || [ \"\${f##*/}\" == \".\" ] || [ -e \${f##*/} ] || exit 1; done", ## Each dotfile must merely exist
        true  => "for f in ${creates}/${dotfiles_dir}/.* ; do [ \"\${f##*/}\" == \"..\" ] || [ \"\${f##*/}\" == \".\" ] || [ \"`readlink \${f##*/}`\" == \"\$f\" ] || exit 1; done", ## Each dotfile must point to the file in the git project
      },
      require  => Dotfiles::Pull["${title}"];
  }

  dotfiles::update { $title:
    gituser     => $gituser,
    homedir     => $real_homedir,
    cwd         => $creates,
    single_pull => $single_pull,
    require     => Dotfiles::Pull["${title}"];
  }

}
