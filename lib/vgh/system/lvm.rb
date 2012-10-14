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
#     lvm = System::LV.new
#     lvm.suspend_lvs
#     # run the code that takes the snapshot
#     lvm.resume_lvs
#
class LV

  # Loads variables and checks if LVM Tools are installed
  def initialize
    @dmcmd = '/sbin/dmsetup'
    installed?
  end

  # Warn message if LVM tools are not installed
  def installed?
    message.warn "LVM Tools are not installed" unless File.exists?(@dmcmd)
  end

  # Test if logical volumes are present
  # @return [Boolean]
  def lvs_are_present?
    lvs_are_present = false
    @lvlist = `#{@dmcmd} ls | /bin/grep -E -v 'swap|root'`
    if @lvlist != "No devices found\n" then
      lvs_are_present = true
    end
    return lvs_are_present
  end

  # Suspend all logical volume
  def suspend
    if lvs_are_present?
      suspend_lvs
    else
      message.info "No logical volumes found."
    end
  end

  # The actual suspend action
  def suspend_lvs
    for lv_name in @lvlist.split[0]
      message.info "Suspending Logical Volume '#{lv_name}'..."
      `#{@dmcmd} suspend #{lv_name}`
    end
  end

  # Resume all logical volumes
  def resume
    if lvs_are_present?
      resume_lvs
    end
  end

  # The actual resume action
  def resume_lvs
     for lv_name in @lvlist.split[0]
      message.info "Resuming Logical Volume '#{lv_name}'..."
      `#{@dmcmd} resume #{lv_name}`
    end
  end

end # class LV
end # module System
end # module VGH

require 'vgh/output'

