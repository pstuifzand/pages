# Copyright 2005 Peter Stuifzand
# This file is part of Pages.
#
# Pages is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Pages is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pages.  If not, see <http://www.gnu.org/licenses/>.

begin
  require 'rubygems'
  require_gem 'BlueCloth'
rescue
  require 'bluecloth'
end
require 'pages/template'

module Pages
module Storage

class Page
  attr_reader :isblog, :outfile, :filename, :infile
  attr_accessor :title, :content

  def initialize(srcdir, filename)
    @infile = srcdir + '/' + filename
    @outfile = filename.sub(/\.tp$/, '.html')
    @filename = filename
    if File.exists?(@infile)
      load
    else
      @title = ''
      @content = ''
    end
  end

  def load
    File.open(@infile) do |file|
      @title = file.readline.chomp
      @content = file.read
    end
  end

  def save
    File.open(@infile, 'w') do |file|
      file.puts(@title)
      file.print(@content)
    end
  end

  def summary
    return BlueCloth.new((@content.split(/\n\n/))[0]).to_html
  end
      
  def to_html
    return BlueCloth.new(@content).to_html
  end
end

end
end

