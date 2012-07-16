default[:rpmbuild_packages] = {
  :packages => Hash.new,
  # packages => {'name-of-specfile' => {:gitrepo   => '',
  #                                     :gitbranch => ''}
  :user     => 'rpmbuild',
  :builddir => '/mnt/rpmbuild/buildrpm'
}
