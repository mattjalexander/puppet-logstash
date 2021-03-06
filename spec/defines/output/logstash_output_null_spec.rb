require 'spec_helper'

describe 'logstash::output::null', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :tags => ['value3'],
      :type => 'value4',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_null_test').with(:content => "output {\n null {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  tags => ['value3']\n  type => \"value4\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :tags => ['value3'],
      :type => 'value4',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_null_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_null_test') }

  end

end
