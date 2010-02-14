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
require 'pages/layout'

module Pages
class GeneratePage
  include Pages::Layout

  attr_reader :website, :srcdir, :outdir, :out

  def initialize(website, srcdir, outdir)
    @website = website
    @outdir = outdir
    @srcdir = srcdir

    @tp = Pages::TemplatePage.new(srcdir)
  end
  
  def outfile(page)
    return @outdir + '/' + page.outfile
  end

  def changed?(page)
    unless File.exists?(outfile(page))
      return true
    end

    last_time = File.mtime(outfile(page))
    
    if File.mtime(@tp.header_file) > last_time
      return true
    elsif File.mtime(@tp.footer_file) > last_time
      return true
    end

    if page.respond_to?(:changed_since) 
      return page.changed_since(last_time)
    elsif page.respond_to?(:infile)
      return File.mtime(page.infile) > last_time
    end

    return false
  end

  def open_file(file)
    # Open the file
    @out = File.new(file, 'w')
  end

  def close_file
    @out.close
  end

  def header(page, title=nil)
    open_file(outfile(page))
    out.puts @tp.header.to_str(@website.template_vars({ 'page_title' => calculate_title(page.title), 'title' => page.title, 'menu' => @website.menu_html }))
  end

  def footer(page, title=nil)
    actual_title = title || page.title
    out.puts @tp.footer.to_str(@website.template_vars({ 'title' => actual_title, 'menu' => @website.menu_html }))
    close_file
  end

  def item(page)
    @out.puts page.to_html
  end

  def generate(page)
    if changed?(page)
      print "."
      $stdout.flush
#      print "Generating #{page.filename} -> '#{page.title}'... "
      header(page)
      item(page)
      footer(page)
      #puts "done"
    end
  end
end
end
