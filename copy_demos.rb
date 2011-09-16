#!/usr/bin/env ruby

class Demo
	def initialize(name,deps)
		@name = name
		@deps = deps
	end
	def get_content
		f = File.open("demo/original/#{@name}.dem")
		data = f.read.gsub(/^(pause.*)$/, '# \1').gsub(/^(print.*)$/, '# \1')
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

transparent_solids = Demo.new('transparent', [])
data = transparent_solids.get_content
transparent_solids.write_file(data)

transparent_solids = Demo.new('transparent_solids', [])
data = transparent_solids.get_content
transparent_solids.write_file(data)

rgbalpha = Demo.new('rgbalpha',['lena.rgb'])
rgbalpha.copy_file

rgb_variable = Demo.new('rgb_variable',['rgb_variable.dat'])
data = rgb_variable.get_content.gsub(/^(splot.*?), \\$/, '\1 notitle, \\')
rgb_variable.write_file(data)

rainbow = Demo.new('rainbow',['colorwheel.dem'])
rainbow.copy_file

pm3dcolors = Demo.new('pm3dcolors',[])
# data = pm3dcolors.get_content.gsub(/(set title.*defined.*?)#(.*?)#(.*?)#(.*?)#(.*)$/, '\1\\#\2\\#\3\\#\4\\#\5')
data = pm3dcolors.get_content.gsub(/(set title.*defined.*?)#(.*?)#(.*?)#(.*?)#(.*)$/, '\1\2\3\4\5')
pm3dcolors.write_file(data)

image = Demo.new('image',['blutux.rgb'])
data = image.get_content.gsub(/# pause.*/m,'').gsub(
	/(plot 'blutux.rgb' binary array=\(128,128\) flipy format='%uchar' with rgbimage)/,
	'\1 title "\'blutux.rgb\' binary array=(128,128) flipy format=\'\\\\\\\\%uchar\' with rgbimage"')
image.write_file(data)
