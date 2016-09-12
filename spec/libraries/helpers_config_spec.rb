# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers_config'

describe ClamavCookbook::Helpers::Config do
  let(:input_conf) { nil }
  let(:config) { described_class.new(input_conf) }

  describe '.from_file' do
    let(:path) { nil }
    let(:input) { nil }
    let(:config) { described_class.from_file(path) }

    before(:each) do
      allow(File).to receive(:open).with(path).and_return(double(read: input))
    end

    context 'an empty file' do
      let(:input) { '' }

      it 'calls from_s with the empty input' do
        expect(described_class).to receive(:from_s).with(input)
        config
      end
    end

    context 'a populated input' do
      let(:input) { "LocalSocket /tmp/sock\nScanPE true" }

      it 'calls from_s with the populated input' do
        expect(described_class).to receive(:from_s).with(input)
        config
      end
    end
  end

  describe '.from_s' do
    let(:input) { nil }
    let(:config) { described_class.from_s(input) }

    shared_examples_for 'any input' do
      it 'returns a new Config object' do
        expect(config).to be_an_instance_of(ClamavCookbook::Helpers::Config)
      end
    end

    context 'an empty input' do
      let(:input) { '' }

      it_behaves_like 'any input'

      it 'generates an empty Config object' do
        expect(config.instance_variable_get(:@config)).to eq({})
      end
    end

    context 'a populated input' do
      let(:input) { "LocalSocket /tmp/sock\nScanPE true" }

      it_behaves_like 'any input'

      it 'generates a populated Config object' do
        expected = { local_socket: '/tmp/sock', scan_p_e: true }
        expect(config.instance_variable_get(:@config)).to eq(expected)
      end
    end

    context 'a populated input with an array attribute' do
      let(:input) do
        <<-EOH.gsub(/^ {10}/, '')
          FixStaleSocket true
          PidFile /var/run/clamav.pid
          DatabaseMirror mirror1
          DatabaseMirror mirror2
          DatabaseMirror mirror3
        EOH
      end

      it_behaves_like 'any input'

      it 'generates a populated Config object' do
        expected = {
          fix_stale_socket: true,
          pid_file: '/var/run/clamav.pid',
          database_mirror: %w(mirror1 mirror2 mirror3)
        }
        expect(config.instance_variable_get(:@config)).to eq(expected)
      end
    end
  end

  describe '.parse_line' do
    let(:input) { nil }
    let(:res) { described_class.parse_line(input) }

    context 'a string value' do
      let(:input) { 'Testing stuff' }

      it 'returns the expected result' do
        expect(res).to eq([:testing, 'stuff'])
      end
    end

    context 'a true value' do
      let(:input) { 'Testing true' }

      it 'returns the expected result' do
        expect(res).to eq([:testing, true])
      end
    end

    context 'a false value' do
      let(:input) { 'Testing false' }

      it 'returns the expected result' do
        expect(res).to eq([:testing, false])
      end
    end
  end

  describe '.initialize' do
    context 'a nil input config' do
      let(:input_conf) { nil }

      it 'saves the input config in an instance variable' do
        expect(config.instance_variable_get(:@config)).to eq({})
      end
    end

    context 'an empty input config' do
      let(:input_conf) { {} }

      it 'saves the input config in an instance variable' do
        expect(config.instance_variable_get(:@config)).to eq(input_conf)
      end
    end

    context 'a populated input config' do
      let(:input_conf) { { local_socket: '/tmp/sock', scan_p_e: true } }

      it 'saves the input config in an instance variable' do
        expect(config.instance_variable_get(:@config)).to eq(input_conf)
      end
    end

    context 'an input config with an array attribute' do
      let(:input_conf) do
        {
          fix_stale_socket: true,
          pid_file: '/var/run/clamav.pid',
          database_mirror: %w(mirror1 mirror2 mirror3)
        }
      end

      it 'saves the input config in an instance variable' do
        expect(config.instance_variable_get(:@config)).to eq(input_conf)
      end
    end
  end

  describe '#to_s' do
    context 'a nil input config' do
      let(:input_conf) { nil }

      it 'returns the expected config file body' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
        EOH
        expect(config.to_s).to eq(expected)
      end
    end

    context 'an empty input config' do
      let(:input_conf) { {} }

      it 'returns the expected config file body' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
        EOH
        expect(config.to_s).to eq(expected)
      end
    end

    context 'a populated input config' do
      let(:input_conf) { { local_socket: '/tmp/sock', scan_p_e: true } }

      it 'returns the expected config file body' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
          LocalSocket /tmp/sock
          ScanPE true
        EOH
        expect(config.to_s).to eq(expected)
      end
    end

    context 'an input config with an array attribute' do
      let(:input_conf) do
        {
          fix_stale_socket: true,
          pid_file: '/var/run/clamav.pid',
          database_mirror: %w(mirror1 mirror2 mirror3)
        }
      end

      it 'returns the expected config file body' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          ##############################################
          # This file generated automatically by Chef. #
          # Any local changes will be overwritten.     #
          ##############################################
          FixStaleSocket true
          PidFile /var/run/clamav.pid
          DatabaseMirror mirror1
          DatabaseMirror mirror2
          DatabaseMirror mirror3
        EOH
        expect(config.to_s).to eq(expected)
      end
    end
  end
end
