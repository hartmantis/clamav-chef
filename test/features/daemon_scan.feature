@enabled
Feature: Virus scan via the running ClamAV daemon

In order to keep my system safe and secure
As a sysadmin
I want to scan for potential viruses via a running daemon

  Scenario: Scan a clean file
     Given a new server with ClamAV enabled
      When I scan a clean file via clamd
      Then ClamAV should detect nothing
    
  Scenario: Scan a virus file
     Given a new server with ClamAV enabled
      When I scan a virus file via clamd
      Then ClamAV should detect a virus

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
