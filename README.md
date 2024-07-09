# read-file

A script to collect an entire file content that is regularly overwritten daily.
This script is intended to be used in [in_exec](https://docs.fluentd.org/input/exec) of [Fluentd](https://www.fluentd.org/).

## Usage

### Options

```console
$ ruby read-file.rb --help
Usage: read-file.rb path [options]
Example: ruby read-file.rb /path/to/file.log --hour 20 --status-file /path/to/status
Example: ruby read-file.rb /path/to/file.log --hour 20 --move

        --encoding ENCODING          Encoding of the file to collect, such as utf-8, shift_jis.
                                     Default: shift_jis
        --hour HOUR                  Execute collection only at this hour.
                                     Default: Disabled
        --move                       Move the file after collecting to prevent duplicate collecting by adding `.collected` extension.
                                     Default: Disabled
        --status-file PATH           Prevent duplicate collecting in the day by keeping the last collecting time in the file.
                                     Default: Disabled
```

### With in_exec of Fluentd

Collect an entire file daily at around 20:00 ~ 20:59.

```xml
<source>
  @type exec
  @id in_exec
  tag test
  command "/opt/fluent/bin/ruby /path/read-file.rb /path/target.log --encoding utf-8 --hour 20 --status-file /path/status"
  run_interval 15m
  <parse>
    @type none
  </parse>
</source>
```

## Test

```console
$ rake
```

## Copyright

* Copyright(c) 2024 Fukuda Daijiro
* License
  * Apache License, Version 2.0
