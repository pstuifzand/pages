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
require 'pages/storage/page'

module Pages
module Storage

class Website
  attr_reader :pages, :options

  def initialize(srcdir, options)
    raise "srcdir == nil" if srcdir == nil
    raise "srcdir #{@srcdir} bestaat niet" if !File.exists?(srcdir)

    @srcdir = srcdir
    @options = options

    @pages = Dir[@srcdir + "/**/*.tp"].reject{|filename| filename.match(/blog\//)}.select{ |filename| filename.match(/\.tp$/) }.map{|f| f.sub(/src\//,'')}.collect{|f| open_page(f) }

#    Dir.open(@srcdir) do |dir|
#      @pages = dir.select{ |filename| filename.match(/\.tp$/) }.collect{|f| open_page(f) }
#    end
  end

  def open_page(filename)
    raise "filename == nil" if filename == nil

    #puts "Opening #{filename}"
    print "."
    $stdout.flush
    return Pages::Storage::Page.new(@srcdir, filename)
  end

  def menu_html
    header_menu = @options['menu']

    menu = '<div id="header-menu">'
    menu += header_menu.map{|val| "<a class=\"#{val['class'] || 'menu-link'}\" href=\"#{val['filename']}\">#{val['title']}</a>"}.join("\n| ")
    menu += "</div>"

    return menu
  end


  def title
    return @options['title']
  end

  def subtitle
    return @options['subtitle']
  end

  def baseurl
    return @options['baseurl']
  end

  def css_file
    return @options['css_file'] || '/new.css'
  end


  def template_vars(vars)
    return { 'menu' => menu_html, 'subtitle' => @options['subtitle'] || '' }.merge(vars)
  end

end


end
end
