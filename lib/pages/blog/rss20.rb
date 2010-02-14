# Copyright 2004 Peter Stuifzand
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
require 'cgi'

module Pages
module Blog
class RSS20
  def initialize(website,srcdir, outdir, config = {})
    @website = website

    filename = config['rss']['file'] || 'rss.xml';
    @outfile = File.new(outdir +'/' + filename, 'w')
    @outfile.sync=true

    @count = 0
    @numitems = 10
  end

  def header
    @outfile.print "<?xml version='1.0'?>"
    @outfile.print <<"HEAD"
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel><title>#{@website.title}</title>
<link>#{@website.baseurl}</link>
<atom:link href="#{@website.baseurl}/rss.xml" rel="self" type="application/rss+xml" />
<description>#{@website.subtitle}</description>
HEAD
  end

  def footer
    @outfile.puts "</channel></rss>"
    @outfile.close
  end

  def item(page)
    @outfile.print <<"ITEM"
<item>
<guid>#{@website.baseurl}/#{page.permfile}</guid>
<title>#{page.title}</title>
<description>#{CGI.escapeHTML(page.to_html)}</description>
<link>#{@website.baseurl}/#{page.permfile}?utm_campaign=rss&amp;utm_source=rss&amp;utm_medium=rss</link>
<pubDate>#{page.date.strftime('%a, %d %b %Y %H:%M:00 +0100')}</pubDate>
</item>
ITEM
    @outfile.flush
    
    @count += 1
    return @numitems == -1 || @count < @numitems
  end
end
end
end
