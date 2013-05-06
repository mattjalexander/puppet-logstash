# == Define: logstash::filter::environment
#
#   Set fields from environment variables
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   environment {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the environment plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_field_from_env*]
#   Specify a hash of fields to the environment variable A hash of matches
#   of field =&gt; environment variable
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   environment {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*exclude_tags*]
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   environment {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*type*]
#   The type to act on. If a type is given, then this filter will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*order*]
#   The order variable decides in which sequence the filters are loaded.
#   Value type is number
#   Default value: 10
#   This variable is optional
#
# [*instances*]
#   Array of instance names to which this define is.
#   Value type is array
#   Default value: [ 'array' ]
#   This variable is optional
#
#
# === Examples
#
#
#
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.10
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.10/filters/environment
#
#  Need help? http://logstash.net/docs/1.1.10/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::environment (
  $add_field          = '',
  $add_field_from_env = '',
  $add_tag            = '',
  $exclude_tags       = '',
  $remove_tag         = '',
  $tags               = '',
  $type               = '',
  $order              = 10,
  $instances          = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_environment_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/environment/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/environment/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($add_field_from_env != '') {
    validate_hash($add_field_from_env)
    $arr_add_field_from_env = inline_template('<%= "["+add_field_from_env.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field_from_env = "  add_field_from_env => ${arr_add_field_from_env}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= "["+add_field.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($order != '') {
    if ! is_numeric($order) {
      fail("\"${order}\" is not a valid order parameter value")
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n environment {\n${opt_add_field}${opt_add_field_from_env}${opt_add_tag}${opt_exclude_tags}${opt_remove_tag}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}
