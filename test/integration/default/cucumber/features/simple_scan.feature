Feature: Simple virus scan
  In order to keep my system safe and secure
  As a sysadmin
  I want to run virus scans on files

  Scenario: Scan a clean file with clamscan
    Given a new server with ClamAV installed
    When I manually scan a clean file
    Then ClamAV detects nothing
    
  Scenario: Scan a virus file with clamscan
    Given a new server with ClamAV installed
    When I manually scan a virus file
    Then ClamAV detects a virus
