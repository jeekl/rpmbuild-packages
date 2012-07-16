# -*- coding: utf-8 -*-
# Cookbook Name:: rpmbuild-packages
# Recipe:: default
#
# Copyright 2012, Jeff Eklund <jeff.eklund@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


packages  = node[:rpmbuild_packages][:packages]
builduser = node[:rpmbuild_packages][:user]
builddir  = node[:rpmbuild_packages][:builddir]

packages.each do |application,attributes|

  specfile = "#{application}.spec"

  # Create specfile on disk
  cookbook_file "#{builddir}/SPECS/#{specfile}" do
    source "#{specfile}"
    mode 0755
    owner builduser
    group builduser
  end

  # determine git branch to use
  branch = attributes[:gitbranch] == '' ? 'master' : attributes[:gitbranch]

  # Check out gitrepo on specified branch
  git "#{builddir}/SOURCES/#{application}" do
    repository attributes[:gitrepo]
    reference branch
    action :sync
    group builduser
    user  builduser
  end

  # create tarball of repo
  execute "create tarball of #{application}" do
    command "tar -zcf #{application}.tar.gz #{application}"
    cwd "#{builddir}/SOURCES/"
    group builduser
    user  builduser
  end

  # build rpm \o/
  cron "build rpm of #{application}" do
    hour "2"
    minute "0"
    user builduser
    command "QA_RPATHS=$[ 0x0001|0x0002 ] rpmbuild -ba #{builddir}/SPECS/#{specfile}"
  end
end
