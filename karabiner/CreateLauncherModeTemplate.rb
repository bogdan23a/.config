#!/usr/bin/env ruby

# You can generate json by executing the following command on Terminal.
#
# $ ruby ./CreateLauncherModeTemplate.rb
#

# Parameters

def parameters
  {
    :simultaneous_threshold_milliseconds => 500
  }
end

############################################################

require 'json'

def main
  data = {
    'description' => 'O-Launcher',
    'manipulators' => [
        generate_launcher_mode('o', 'n', [], [{ 'shell_command' => "open -a 'notion.app'" }]),
        generate_launcher_mode('o', 'b', [], [{ 'shell_command' => "open -a 'Brave Browser.app'" }]),
        generate_launcher_mode('o', 'a', [], [{ 'shell_command' => "open -a 'Activity Monitor.app'" }]),
        generate_launcher_mode('o', 'c', [], [{ 'shell_command' => "open -a 'Visual Studio Code.app'" }]),
        # generate_launcher_mode('left_control', '', ['left_control'], [{ 'shell_command' => "open -a 'iTerm.app'" }]),
        generate_launcher_mode('o', 'f', [], [{ 'shell_command' => "open -a 'FaceTime.app'" }]),
        generate_launcher_mode('o', 's', [], [{ 'shell_command' => "open -a 'Screen Sharing.app'" }])

    ].flatten,
  }

  puts JSON.pretty_generate(data)
end

def generate_launcher_mode(trigger_key, from_key_code, mandatory_modifiers, to)
  data = []

  ############################################################

  h = {
    'type' => 'basic',
    'from' => {
      'key_code' => from_key_code,
      'modifiers' => {
        'mandatory' => mandatory_modifiers,
        'optional' => [
          'any',
        ],
      },
    },
    'to' => to,
    'conditions' => [
      {
        'type' => 'variable_if',
        'name' => 'launcher_mode',
        'value' => 1,
      },
    ],
  }

  data << h

  ############################################################

  h = {
    'type' => 'basic',
    'from' => {
      'simultaneous' => [
        {
          'key_code' => trigger_key,
        },
        {
          'key_code' => from_key_code,
        },
      ],
      'simultaneous_options' => {
        'key_down_order' => 'strict',
        'key_up_order' => 'strict_inverse',
        'to_after_key_up' => [
          {
            'set_variable' => {
              'name' => 'launcher_mode',
              'value' => 0,
            },
          },
        ],
      },
      'modifiers' => {
        'mandatory' => mandatory_modifiers,
        'optional' => [
          'any',
        ],
      },
    },
    'to' => [
      {
        'set_variable' => {
          'name' => 'launcher_mode',
          'value' => 1,
        },
      },
    ].concat(to),
    'parameters' => {
      'basic.simultaneous_threshold_milliseconds' => parameters[:simultaneous_threshold_milliseconds],
    },
  }

  data << h

  ############################################################

  data
end

main