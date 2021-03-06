require 'spec_helper'

describe 'logstash::input::varnishlog', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value5',
      :tags => ['value6'],
      :threads => 7,
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_varnishlog_test').with(:content => "input {\n varnishlog {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  message_format => \"value5\"\n  tags => ['value6']\n  threads => 7\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value5',
      :tags => ['value6'],
      :threads => 7,
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_varnishlog_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_varnishlog_test') }

  end

end
