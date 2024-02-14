class CronParser
  def initialize(cron_string)
    @cron_string = cron_string
    @fields = cron_string.split(" ")
  end

  def parse
    {
      "minute" => expand_field(@fields[0], 0..59),
      "hour" => expand_field(@fields[1], 0..23),
      "day of month" => expand_field(@fields[2], 1..31),
      "month" => expand_field(@fields[3], 1..12),
      "day of week" => expand_field(@fields[4], 0..6),
      "command" => @fields[5..-1].join(" ")
    }
  end

  private

  def expand_field(field, range)
    if field.include?(',')
      expanded = field.split(',').map { |f| expand_single_field(f, range) }.flatten.uniq.sort
    else
      expanded = expand_single_field(field, range)
    end
    expanded.join(" ")
  end

  def expand_single_field(field, range)
    if field.include?('/')
      step = field.split('/')[1].to_i
      field = field.split('/')[0]
    else
      step = 1
    end

    if field.include?('-')
      start, stop = field.split('-').map(&:to_i)
      expanded = (start..stop).step(step).to_a & range.to_a
    elsif field == '*'
      expanded = range.step(step).to_a
    else
      expanded = [field.to_i]
    end
    expanded.map { |value| value.to_s.rjust(2, '0') }
  end
end

def format_output(parsed_cron)
  parsed_cron.map do |key, value|
    value = value.split(' ') unless value.is_a?(Array)
    "#{key.ljust(14)} #{value.join(' ')}"
  end.join("\n")
end

if __FILE__ == $0
  cron_string = ARGV[0]
  parser = CronParser.new(cron_string)
  parsed_cron = parser.parse
  puts format_output(parsed_cron)
end