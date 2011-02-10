#!/usr/bin/env ruby

class Demo
	def initialize(name,deps)
		@name = name
		@deps = deps
	end
	def get_content
		f = File.open("demo/original/#{@name}.dem")
		data = f.read.gsub(/^(pause.*)$/, '# \1')
		f.close
		return data
	end
	def write_file(data)
		f = File.open("demo/tex/#{@name}.dem", "w")
		f.write data
		f.close

		@deps.each do |dep|
			system "cp -p demo/original/#{dep} demo/tex/"
		end
	end
	def copy_file
		write_file(get_content)
	end
end

circles = Demo.new('circles',
	['world.dat','world.cor','energy_circles.dat','optimize.dat',
	 'lena.rgb','lena-keypoints.bin','empty-circles.dat','delaunay-edges.dat','hemisphr.dat'])
circles.copy_file

fillcrvs = Demo.new('fillcrvs', ['world.dat'])
data = fillcrvs.get_content
# data.gsub!(/(\(x>3.5 \? x\/3-3 : 1\/0\))/, '\1 t \'$(x>3.5?x/3-3:1/0)$\'')
# data.scan(/\s+([^\s]+)\s+([^\s]+)\s+with/) do |t1,t2|
# 	puts ">>#{t1}<<\n>>#{t2}<<\n\n"
# end
fillcrvs.write_file(data)

transparent_solids = Demo.new('transparent_solids', [])
data = transparent_solids.get_content
transparent_solids.write_file(data)