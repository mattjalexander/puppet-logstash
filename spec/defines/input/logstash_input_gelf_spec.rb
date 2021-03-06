require 'spec_helper'

describe 'logstash::input::gelf', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :port => 7,
      :remap => false,
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_gelf_test').with(:content => "input {\n gelf {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value5\"\n  message_format => \"value6\"\n  port => 7\n  remap => false\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :port => 7,
      :remap => false,
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_gelf_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_gelf_test') }

  end

end
