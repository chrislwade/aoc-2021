(1..25).map {|day| 'day%02i' % [day]}.each do |day|
  begin
    require day
    klass = Kernel.const_get(day.capitalize)

    RSpec.describe klass do
      context 'with the demo file' do
        describe :puzzle1 do
          it "should be #{klass.expected[:puzzle1]}" do
            expect(klass.new(fixture("#{day}.txt").path).puzzle1).to eq(klass.expected[:puzzle1])
          end
        end

        describe :puzzle2 do
          it "should be #{klass.expected[:puzzle2]}" do
            expect(klass.new(fixture("#{day}.txt").path).puzzle2).to eq(klass.expected[:puzzle2])
          end
        end
      end
    end
  rescue LoadError => exception
    # no-op, day isn't implemented yet
  end
end