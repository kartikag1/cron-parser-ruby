class CronParser
  def initialize(cron_string)
    @cron_string = cron_string
    @fields = cron_string.split(" ") # to separate out the 6 fields
  end

  def parse
    {
      "minute" => expand_field(@fields[0], 0..59),
      "hour" => expand_field(@fields[1], 0..23),
      "day of month" => expand_field(@fields[2], 1..31),
      "month" => expand_field(@fields[3], 1..12),
      "day of week" => expand_field(@fields[4], 0..7),
      "command" => @fields[5..-1].join(" ")
    }
  end

  private

  def expand_field(field, range)
    # field can be of the following types:
    # 1. A comma-separated list of values (e.g., 1,15,30)
    # 2. A single value (e.g., 5)
    # 3. A range of values (e.g., 1-5)
    # 4. An asterisk * to indicate all possible values
    # 5. Step values (e.g., */15 for every 15 minutes)

    if field.include?(',')
      # Handling field type 1
      expanded = field.split(',').map { |f| expand_single_field(f, range) }.flatten.uniq.sort
    else
      # Handling field type 2-5
      expanded = expand_single_field(field, range)
    end
    expanded.join(" ")
  end

  def expand_single_field(field, range)
    # Handling field type 5
    if field.include?('/')
      step = field.split('/')[1].to_i
      field = field.split('/')[0]
    else
      step = 1
    end

    if field.include?('-')
      # Handling field type 3
      start, stop = field.split('-').map(&:to_i)
      expanded = (start..stop).step(step).to_a & range.to_a # intersection to ensure the expanded values are within the range
    elsif field == '*'
      # Handling field type 4
      expanded = range.step(step).to_a
    else
      # Handling field type 2
      expanded = [field.to_i]
    end
    expanded.map { |value| value.to_s }
  end
end

def format_output(parsed_cron)
  parsed_cron.map do |key, value|
    value = value.split(' ') unless value.is_a?(Array)
    "#{key.ljust(14)} #{value.join(' ')}" # left justify to align the output
  end.join("\n")
end

if __FILE__ == $0 # if the script is being run directly
  cron_string = ARGV[0] # picks up the argument from the command line
  parser = CronParser.new(cron_string)
  parsed_cron = parser.parse
  puts format_output(parsed_cron)
end
