# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/helpers_config'

describe ClamavCookbook::Helpers::Config do
  let(:input_conf) { nil }
  let(:config) { described_class.new(input_conf) }

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
        expect(config.to_s).to eq('')
      end
    end

    context 'an empty input config' do
      let(:input_conf) { {} }

      it 'returns the expected config file body' do
        expect(config.to_s).to eq('')
      end
    end

    context 'a populated input config' do
      let(:input_conf) { { local_socket: '/tmp/sock', scan_p_e: true } }

      it 'returns the expected config file body' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
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
