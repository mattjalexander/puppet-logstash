require 'spec_helper'

describe 'logstash::input::pipe', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :command => 'value3',
      :debug => false,
      :format => 'plain',
      :message_format => 'value6',
      :tags => ['value7'],
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_pipe_test').with(:content => "input {\n pipe {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  command => \"value3\"\n  debug => false\n  format => \"plain\"\n  message_format => \"value6\"\n  tags => ['value7']\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :command => 'value3',
      :debug => false,
      :format => 'plain',
      :message_format => 'value6',
      :tags => ['value7'],
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_pipe_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_pipe_test') }

  end

end
