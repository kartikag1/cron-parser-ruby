require 'rspec'
require_relative 'cron_parser'

RSpec.describe CronParser do
  describe '#parse' do
    context 'when given a valid cron string' do
      let(:cron_string) { "*/15 0 1,15 * 1-5 /usr/bin/find" }
      let(:expected_output) do
        {
          "minute" => "0 15 30 45",
          "hour" => "0",
          "day of month" => "1 15",
          "month" => "1 2 3 4 5 6 7 8 9 10 11 12",
          "day of week" => "1 2 3 4 5",
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
          "minute" => "0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58",
          "hour" => "0 3 6 9 12 15 18 21",
          "day of month" => "1 3 5",
          "month" => "1 5 9",
          "day of week" => "0 5",
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
          "minute" => "0 10 20 30 40 50",
          "hour" => "3 4 5",
          "day of month" => "1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31",
          "month" => "1 2 3",
          "day of week" => "0 4",
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
