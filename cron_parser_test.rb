require 'rspec'
require_relative 'cron_parser'

RSpec.describe CronParser do
  describe '#parse' do
    context 'when given a valid cron string' do
      let(:cron_string) { "*/15 0 1,15 * 1-5 /usr/bin/find" }
      let(:expected_output) do
        {
          "minute" => "00 15 30 45",
          "hour" => "00",
          "day of month" => "01 15",
          "month" => "01 02 03 04 05 06 07 08 09 10 11 12",
          "day of week" => "01 02 03 04 05",
          "command" => "/usr/bin/find"
        }
      end

      it 'returns the expected parsed cron fields' do
        parser = CronParser.new(cron_string)
        parsed_cron = parser.parse
        expect(parsed_cron).to eq(expected_output)
      end
    end

    context 'when given a cron string with step values' do
      let(:cron_string) { "*/2 */3 1-5/2 */4 */5 /usr/bin/find" }
      let(:expected_output) do
        {
          "minute" => "00 02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58",
          "hour" => "00 03 06 09 12 15 18 21",
          "day of month" => "01 03 05",
          "month" => "01 05 09",
          "day of week" => "00 05",
          "command" => "/usr/bin/find"
        }
      end

      it 'returns the expected parsed cron fields' do
        parser = CronParser.new(cron_string)
        parsed_cron = parser.parse
        expect(parsed_cron).to eq(expected_output)
      end
    end

    context 'when given a cron string with ranges' do
      let(:cron_string) { "*/10 3-5 */2 1-3 */4 /usr/bin/find" }
      let(:expected_output) do
        {
          "minute" => "00 10 20 30 40 50",
          "hour" => "03 04 05",
          "day of month" => "01 03 05 07 09 11 13 15 17 19 21 23 25 27 29 31",
          "month" => "01 02 03",
          "day of week" => "00 04",
          "command" => "/usr/bin/find"
        }
      end

      it 'returns the expected parsed cron fields' do
        parser = CronParser.new(cron_string)
        parsed_cron = parser.parse
        expect(parsed_cron).to eq(expected_output)
      end
    end
  end
end
