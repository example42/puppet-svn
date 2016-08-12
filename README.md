# Deprecation notice

This module was designed for Puppet versions 2 and 3. It should work also on Puppet 4 but doesn't use any of its features.

The current Puppet 3 compatible codebase is no longer actively maintained by example42.

Still, Pull Requests that fix bugs or introduce backwards compatible features will be accepted.


# Puppet module: svn

This is a Puppet module for svn
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-svn

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install svn with default settings

        class { 'svn': }

* Install a specific version of svn package

        class { 'svn':
          version => '1.0.1',
        }

* Remove svn resources

        class { 'svn':
          absent => true
        }

* Enable auditing without without making changes on existing svn configuration *files*

        class { 'svn':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'svn':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'svn':
          source => [ "puppet:///modules/example42/svn/svn.conf-${hostname}" , "puppet:///modules/example42/svn/svn.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'svn':
          source_dir       => 'puppet:///modules/example42/svn/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'svn':
          template => 'example42/svn/svn.conf.erb',
        }

* Automatically include a custom subclass

        class { 'svn':
          my_class => 'example42::my_svn',
        }


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/example42/puppet-svn.png?branch=master" alt="Build Status" />}[https://travis-ci.org/example42/puppet-svn]
