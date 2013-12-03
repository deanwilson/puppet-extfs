Puppet::Type.newtype(:extfs_reserved) do

  desc "Manage the amount of space reserved for the root user on
        an ext filesystem.


        extfs_reserved { '/dev/mapper/vg_logs-lv_mysql':
          ensure  => 'present',
          reserve => '5%', 
        }


        extfs_reserved { '/dev/mapper/vg_novakvm02-lv_root':
          ensure           => 'present',
          reservation_type => 'block',
          reserve          => 1550,
        }

  "

  ensurable


  newparam(:path, :namevar => true) do
    desc "The device path to operate on."
  end


  newparam(:reservation_type) do
    desc "The type of reservation to set, 'percent' or 'block'"

    newvalues :percent, :block
    defaultto :percent
  end


  newparam(:reserve) do
    desc "The amount to reserve. Given as absolute blocks or a percentage"

    munge do |value|
      value.sub(/(\d+)%?/, '\1') # remove % from input
    end

    validate do |value|
      unless value.to_s.match(/^\d+%?$/)
        raise ArgumentError, "Reserved space must be specified as integer, not #{value}"
      end
    end
  end


end
