define drbdmanage::apt (
) {
  apt::key { 'drbd9':
    key => '781F830A',
    key_server => 'keyserver.ubuntu.com',
  }

  apt::source { 'drbd9':
    location => "http://ppa.launchpad.net/martin-loschwitz/drbd9-ppa/",
    release => $::lsbdistcodename,
    require => Apt::Key['drbd9'],
    before => [ Package['drbdmanage'],
                Package['drbd-dkms'],
		Package['drbd-utils']
	        ]
  }
}
