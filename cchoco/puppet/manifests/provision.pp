# dont install Chocolatey as we will do that as part of the DSC resource

pspackageprovider {'Nuget':
  ensure => 'present'
}

psrepository { 'PSGallery':
  ensure              => present,
  source_location     => 'https://www.powershellgallery.com/api/v2/',
  installation_policy => 'trusted',
}

package { 'xPSDesiredStateConfiguration':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'cChoco':
  ensure   => latest,
  source   => 'PSGallery',
  provider => 'windowspowershell',
}
