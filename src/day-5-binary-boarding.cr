require "option_parser"
require "benchmark"
require "string_scanner"

file_name = ""
benchmark = false

ROW_KEY = {'F' => '0', 'B' => '1'}
COL_KEY = {'L' => '0', 'R' => '1'}

OptionParser.parse do |parser|
  parser.banner = "Welcome to Report Repair"

  parser.on "-f FILE", "--file=FILE", "Input file" do |file|
    file_name = file
  end
  parser.on "-b", "--benchmark", "Measure benchmarks" do
    benchmark = true
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

unless file_name.empty?
  seats = File.read_lines(file_name)

  passes = [] of BoardingPass

  seats.each do |pass|
    passes << BoardingPass.new(pass)
  end

  max = 0
  id_list = [] of Int32
  passes.each do |pass|
    id_list << pass.id
    max = pass.id if pass.id > max
  end
  puts "Maximum seat ID #{max}"

  self_seat = 0
  (0..max).each do |id|
    self_seat = id unless (id_list.includes? id) if (id_list.includes? (id + 1)) if (id_list.includes? (id - 1))
  end

  puts "seat left: #{self_seat}"
end

class BoardingPass
  @row : Int32
  @column : Int32
  getter id : Int32

  def initialize(input : String)
    row = input[0..6]
    column = input[7..9]

    row = row.gsub(ROW_KEY)
    column = column.gsub(COL_KEY)

    @row = row.to_i(2)
    @column = column.to_i(2)

    @id = @row * 8 + @column

    puts "Row: #{@row}, Column #{@column}, ID: #{@id}"
  end
end 