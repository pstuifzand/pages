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
require 'pages/template'
require 'pages/layout'

module Pages
module Blog
class List
  include Pages::Layout

  attr_reader :filename, :entries, :website

  def initialize(website, srcdir, outdir, filename, options={})
    @website = website

    @options = options
    @options['numitems'] ||= -1
    @options['title']    ||= ''
    @options['subtitle'] ||= ''
    @options['extra']    ||= ''
    @comments_on = options['comments_on'] || false

    @srcdir = srcdir

    @tp = Pages::TemplatePage.new(srcdir)
    @filename=filename

    #puts "Using #{@filename}"

    @out = File.new(File.join(outdir, filename), 'w')
    @entries = []
  end

  def count
    return @entries.size
  end

  def title 
    return @options['title']
  end

  def simple_title
    return @options['simple_title']
  end

  def year
    return @options['year']
  end

  def header(title=nil)
    actual_title = title || @options['title']

    show_header(@out, actual_title)

    @out.puts @tp.header.to_str(@website.template_vars({ 'page_title' => calculate_title(actual_title), 'title' => actual_title, 'extra' => @options['extra'] }.merge(@options)))
    @out.puts "<div id='blog'>"
  end

  def footer
    actual_title = title || @options['title']
    @out.puts "<div style='text-align:center'><a href='/archive.html'>View archived entries</a></div>"
    @out.puts "</div>"

    @out.puts @tp.footer.to_str(@website.template_vars({ 'title' => actual_title, 'extra' => @options['extra'] }.merge(@options)))
    @out.close
  end

  def item(page)
    @out.puts("<div class='entry'>")
    @out.puts(page_title_header(page))
    @out.puts(page.to_html)
    @out.puts(page_title_footer(page))
    @out.puts("</div>")

    @entries.push({ :title => page.title, :link => '/' + page.permfile})

    return @options['numitems'] == -1 || count < @options['numitems']
  end

  # FIXME: move?
  def page_title_header(page)
    str = ''
    str += "<div class='byline'>"
    if (@options['byline'])
      str += "Peter Stuifzand on " 
    else
      str += 'On '
    end
    str += "<span class='date'>#{page.posted_on}</span></div>"
    str += "<h2 class='title'><a href='/#{page.permfile}' class='permalink'>#{page.title}</a></h2>"
  end

  # FIXME: move?
  def page_title_footer(page)
    txt = <<"HTML"
<div class='footer' style='display:block; height:40px;clear:both'>
HTML
    if @comments_on
      txt += <<"HTML"
    <p><a href="/#{page.permfile}#disqus_thread">Post a comment</a></p>
HTML
    end

    txt += "</div>"
    return txt
  end
  
end

end
end

