Puppet::Type.type(:extfs_reserved).provide(:extfs_reserved, :parent => Puppet::Provider) do

  desc "Manage the space reservation on a device"

  commands :tune2fs => '/sbin/tune2fs'

  def create
    Puppet.debug("Setting #{@resource[:reservation_type]} reservation on #{resource[:name]}")

    cmd_option = case @resource[:reservation_type]
      when :block   then '-r'
      when :percent then '-m'
      else raise Puppet::Error, "Unknown reservation_type #{@resource[:reservation_type]}"
    end

    tune2fs(cmd_option, @resource[:reserve], @resource[:name])
  end


  def destroy
    # doesn't really make sense in the context of this provider
    Puppet.debug("Setting reservation on #{resource[:name]}")
  end


  def exists?
    blocks = get_reservations

    if @resource[:reservation_type] == :block
      return true if @resource[:reserve].to_i == blocks['reserved_block_count']
    else
      percent_reserved = calc_percentage(blocks)
      return true if @resource[:reserve].to_f == percent_reserved
    end

    false
  end

  ################################

  def get_reservations
    blocks = {}
    output = tune2fs('-l', @resource[:name]).grep(/block count/i)

    output.each do |line|
      column, value = line.split(':')
      
      column.gsub!(/ /, '_')
      value.strip!

      blocks[column.downcase] = value.to_i
    end

    blocks
  end


  def calc_percentage(blocks)
    blocks['reserved_block_count'].to_f / blocks['block_count'].to_f * 100
  end

end
