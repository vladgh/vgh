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

  # Loads variables and checks if LVM Tools are installed
  def initialize
    installed?
  end

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
    if ( installed? and System.is_root? )
      @lvs ||= `#{dm_cmd} ls | /bin/grep -E -v 'swap|root'`
    else
      message.warn "Listing logical volume needs root privileges!"
      return nil
    end
  end

  # Test if logical volumes are present
  # @return [Boolean]
  def lvs_are_present?
    if lvs != "No devices found\n" then
      return true
    else
      message.info "No logical volumes found."
      return false
    end
  end

  # Suspend all logical volume
  def suspend
    suspend_lvs if lvs_are_present?
  end

  # The actual suspend action
  def suspend_lvs
    for lv_name in lvs.split[0]
      message.info "Suspending Logical Volume '#{lv_name}'..."
      `#{dm_cmd} suspend #{lv_name}`
    end
  end

  # Resume all logical volumes
  def resume
    resume_lvs if lvs_are_present?
  end

  # The actual resume action
  def resume_lvs
    for lv_name in lvs.split[0]
      message.info "Resuming Logical Volume '#{lv_name}'..."
      `#{dm_cmd} resume #{lv_name}`
    end
  end

end # class LVM
end # module System
end # module VGH

require 'vgh/output'
require 'vgh/system'

