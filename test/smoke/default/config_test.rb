# encoding: utf-8
# frozen_string_literal: true

case os[:family]
when 'debian'
  describe file('/etc/clamav/clamd.conf') do
    its(:content) do
      expected = <<-EOH.gsub(/^ +/, '').strip
        ##############################################
        # This file generated automatically by Chef. #
        # Any local changes will be overwritten.     #
        ##############################################
        BytecodeTimeout 60000
        DatabaseDirectory /var/lib/clamav
        ExtendedDetectionInfo true
        LocalSocket /var/run/clamav/clamd.ctl
        LogFile /var/log/clamav/clamav.log
        LogFileMaxSize 0
        LogRotate true
        LogTime true
        MaxConnectionQueueLength 15
        MaxThreads 12
        ReadTimeout 180
        SelfCheck 3600
        SendBufTimeout 200
        User clamav
      EOH
      should { eq(expected) }
    end
  end

  describe file('/etc/clamav/freshclam.conf') do
    its(:content) do
      expected = <<-EOH.gsub(/^ +/, '').strip
        ##############################################
        # This file generated automatically by Chef. #
        # Any local changes will be overwritten.     #
        ##############################################
        Checks 24
        ConnectTimeout 30
        DatabaseMirror db.local.clamav.net
        DatabaseMirror database.clamav.net
        DatabaseOwner clamav
        LogFileMaxSize 0
        LogRotate true
        LogTime true
        MaxAttempts 5
        NotifyClamd /etc/clamav/clamd.conf
        UpdateLogFile /var/log/clamav/freshclam.log
      EOH
      should { eq(expected) }
    end
  end
end
