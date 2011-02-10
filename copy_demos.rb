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
end

circles = Demo.new('circles',
	['world.dat','world.cor','energy_circles.dat','optimize.dat',
	 'lena.rgb','lena-keypoints.bin','empty-circles.dat','delaunay-edges.dat','hemisphr.dat'])
data = circles.get_content
circles.write_file(data)
