# Description
Takes a specfile, a git repo and a git branch as attributes and builds an rpm of
said specfile.

# Requirements
## Cookbooks
Depends on [rpmbuild cookbook](https://github.com/jeekl/rpmbuild.git).
## Platform
Only tested on
- Centos 5
- Centos 6

# Attributes
What packages you build is controlled by attributes. You add a spec-file to the
files/ directory and then add that spec name to the packages-attribute along with
a git repository and a branch to build from.

For example, say you want to package two versions of Erlang, you place two
specfiles in *files/default* named *erlang_R14-B03.spec* and *erlang_R15-B01.spec*
and specify something like this:
```
  :rpmbuild_packages => {:packages =>
                         {'erlang_R14-B03' =>
                          {:gitrepo   => 'git://git/otp.git',
                           :gitbranch => 'otp_r14b03'},
                          'erlang_R15-B01' =>
                          {:gitrepo   => 'git://git/otp.git',
                           :gitbranch => 'otp_r15b01'}}}
```
This will fetch the specified branches from the specified repos, build a tarball
of the repo and try to run rpmbuild with the specified specfiles. Add a little
rsync-script that moves the rpms to your local repo and you're done.

# Usage
Add specfiles for whatever you want to build to *files/default* (or
*files/centos-5*, *files/centos-6*) and add the specnames and git information as
attributes. The default recipe will fetch the git repos and build rpms at 0200 in
morning.
