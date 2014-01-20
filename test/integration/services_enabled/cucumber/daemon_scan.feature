Feature: Virus scan via the running ClamAV daemon
  In order to keep my system safe and secure
  As a sysadmin
  I want to scan for potential viruses via a running daemon

  Scenario: Scan a clean file with clamdscan
    Given a new server with ClamAV enabled
    When I scan a clean file via clamd
    Then ClamAV detects nothing
    
  Scenario: Scan a virus file with clamdscan
    Given a new server with ClamAV enabled
    When I scan a virus file via clamd
    Then ClamAV detects a virus
