require 'spec_helper'

describe 'logstash::filter::xml', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :source => 'value5',
      :store_xml => false,
      :tags => ['value7'],
      :target => 'value8',
      :type => 'value9',
      :xpath => { 'field10' => 'value10' },
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_xml_test').with(:content => "filter {\n xml {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  remove_tag => ['value4']\n  source => \"value5\"\n  store_xml => false\n  tags => ['value7']\n  target => \"value8\"\n  type => \"value9\"\n  xpath => [\"field10\", \"value10\"]\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :source => 'value5',
      :store_xml => false,
      :tags => ['value7'],
      :target => 'value8',
      :type => 'value9',
      :xpath => { 'field10' => 'value10' },
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_xml_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_xml_test') }

  end

end
