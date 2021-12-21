def puzzle(filename)
  File.join(File.expand_path('../../input/', __FILE__), filename)
end

def sample(day, part = 1)
  part = fixture("#{day}.#{part}.txt").path
  day  = fixture("#{day}.txt").path
  File.exists?(part) ? part : day
end

def skip?(value)
  if value == :skipped
    skip 'no test value provided'
  end
end

(1..25).map {|day| 'day%02i' % [day]}.each do |day|
  begin
    require day
    klass = Kernel.const_get(day.capitalize)

    RSpec.describe klass, focus: klass.focus do
      context 'with the sample file' do
        describe :puzzle1 do
          it "should be #{klass.sample[:puzzle1]}" do
            skip?(klass.sample[:puzzle1])
            expect(klass.new(sample(day, 1)).puzzle1).to eq(klass.sample[:puzzle1])
          end
        end

        describe :puzzle2 do
          it "should be #{klass.sample[:puzzle2]}" do
            skip?(klass.sample[:puzzle2])
            expect(klass.new(sample(day, 2)).puzzle2).to eq(klass.sample[:puzzle2])
          end
        end
      end

      context 'with the puzzle input file' do
        describe :puzzle1 do
          it "should be #{klass.expected[:puzzle1]}" do
            skip?(klass.expected[:puzzle1])
            expect(klass.new(puzzle("#{day}.txt")).puzzle1).to eq(klass.expected[:puzzle1])
          end
        end

        describe :puzzle2 do
          it "should be #{klass.expected[:puzzle2]}" do
            skip?(klass.expected[:puzzle2])
            expect(klass.new(puzzle("#{day}.txt")).puzzle2).to eq(klass.expected[:puzzle2])
          end
        end
      end
    end
  rescue LoadError
    # no-op, day isn't implemented yet
  end
end