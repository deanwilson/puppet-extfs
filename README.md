# Manage aspects of an Ext File system - Puppet Provider #

The first provider in this module is extfs_reserved. It's a simple type
and provider to manage the amount of space reserved for the root user on
an ext file system. You specify the reservations in either blocks or as a percentage


    extfs_reserved { '/dev/mapper/vg_logs-lv_mysql':
      ensure  => 'present',
      reserve => '5%',
    }


    extfs_reserved { '/dev/mapper/vg_novakvm02-lv_root':
      ensure           => 'present',
      reservation_type => 'block',
      reserve          => 1550,
    }

This provider uses the tune2fs binary from the e2fsprogs package (on
RedHat derived distros). While it is a functional provider it was written
as a simple proof of concept to show how you can inline what was an exec.
