# Cron Parser

Cron Parser is a tool written in Ruby that parses a cron expression and generates a human-readable representation of the cron schedule in a tabular format.

## Features

- Parses standard cron expressions.
- Generates a tabular representation of the cron schedule, including minute, hour, day of month, month, and day of week.
- Handles both single values and ranges in the expression.

## Installation

1. Ensure you have Ruby installed on your system.
2. Clone this repository to your local machine.

```bash
https://github.com/kartikag1/cron-parser-ruby.git
```

3. Navigate to the directory containing the cloned repository.

```bash
cd cron-parser-ruby
```

## Usage

Run the `cron_parser.rb` script and provide a cron expression as a command-line argument.

```bash
ruby cron_parser.rb "*/10 0 1,15 * 1-5 /usr/bin/find"
```

Replace `"*/10 0 1,15 * 1-5 /usr/bin/find"` with your desired cron expression.

## Example

Input: `"*/10 0 1,15 * 1-5 /usr/bin/find"`

Output:

```
minute         00 10 20 30 40 50
hour           00
day of month   01 15
month          01 02 03 04 05 06 07 08 09 10 11 12
day of week    01 02 03 04 05
command        /usr/bin/find
```

## Cron Expression Format

The cron expression format consists of five fields separated by spaces:

1. Minute (0-59)
2. Hour (0-23)
3. Day of Month (1-31)
4. Month (1-12 or names)
5. Day of Week (0-7 or names, 0 and 7 represent Sunday)

Each field can contain:

- A single value (e.g., `5`)
- A comma-separated list of values (e.g., `1,15,30`)
- A range of values (e.g., `1-5`)
- An asterisk `*` to indicate all possible values
- Step values (e.g., `*/15` for every 15 minutes)

