module VGH
module System

# This class is able to suspend or resume logical volumes. The +lvm2+ package
# needs to be installed for this to work.
#
# Suspending a volume becomes useful if you want for example a consistent
# EC2 snapshot of it. Any I/O that has already been mapped by the device but
# has not yet completed will be flushed. Any further I/O to that device will
# be postponed for as long as the device is suspended.
#
#
# == Usage:
#
#     lvm = System::LVM.new
#     lvm.suspend
#     # run the code that takes the snapshot
#     lvm.resume
#
class LVM

  # @return [String] The dmsetup system command
  def dm_cmd
    @dmcmd ||= '/sbin/dmsetup'
  end

  # Warn message if LVM tools are not installed
  def installed?
    if File.exists?(dm_cmd)
      return true
    else
      message.warn "LVM Tools are not installed"
      return false
    end
  end

  # @return [String] A list of logical volumes present
  def lvs
    @lvs = []
    if ( installed? and System.is_root? )
      lv_list = `#{dm_cmd} ls | /bin/grep -E -v 'swap|root'`
      @lvs.push(lv_list.split[0]) unless lv_list == "No devices found\n"
    else
      message.warn "Listing logical volume needs root privileges!"
    end
    return @lvs
  end

  # The actual suspend action
  def suspend
    for lv_name in lvs
      message.info "Suspending Logical Volume '#{lv_name}'..."
      `#{dm_cmd} suspend #{lv_name}`
    end
  end

  # The actual resume action
  def resume
    for lv_name in lvs
      message.info "Resuming Logical Volume '#{lv_name}'..."
      `#{dm_cmd} resume #{lv_name}`
    end
  end

end # class LVM
end # module System
end # module VGH

require 'vgh/output'
require 'vgh/system'

