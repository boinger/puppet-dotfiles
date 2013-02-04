puppet-dotfiles
===============

* Pull/update users' dotfiles projects from github

##Requirements##

* git
* Public project named "dotfiles" in your github account

##Usage##

###Basic
```puppet
  dotfiles { 'jv': gituser => 'boinger'; }
```

###With overrides
Default values (other than $gituser, which has no default, of course) shown
```puppet
  dotfiles {'jv':
      gituser      => 'boinger',
      giturl       => "git://github.com",
      project      => "dotfiles",
      dotfiles_dir => "home",
      branch       => "master",
      homedir      => "/home/${name}"
      clobber      => true,
      bak_ext      => '.bak',
      single_pull  => false,
      rebase       => true;
  }
```

## Fields
* gituser: Your github username
* giturl: If you for some reason aren't using the normal github base URL
* project: Name of your dotfiles project
* dotfiles_dir: Subdirectory under your dotfiles project containing the dotfiles. <br />
(.bashrc, .bash_profile, .zshrc, .nethackrc, etc, etc)
* branch: If you want to pull a specific branch of your dotfiles project
* homedir: Your home directory on the puppet-managed host
* clobber: insert dotfiles, moving any existing conflicts out of the way
* bak_ext: extension to append to filenames of existing files to get them out of the way.  Only matters if you have $clobber = true.
* single_pull: Option to pull down the dotfiles one time only (no recurring pulls)
* rebase: If you prefer `git pull --rebase` to `git pull` (you probably want this)

##License##

 Copyright (C) 2013 Jeff Vier <jeff@jeffvier.com> (Author)<br />
 License: Apache 2.0
