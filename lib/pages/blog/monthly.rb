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
# This class already does two things.
# - generate an index page for the month pages
# - generate the month pages

require 'pages/layout'

module Pages
module Blog
  class Monthly
    include Pages::Layout

    def initialize(website, srcdir, outdir, filename, options)
      @website = website
      @srcdir = srcdir
      @outdir = outdir
      @config = options

      @pages = {}
      @archive = File.new(File.join(outdir, filename), 'w')
      @tp = TemplatePage.new(srcdir)
    end

    def header
      actual_title = 'Archived p/month'

      css_file = @config['css_file'] || '/new.css'

      show_header(@archive, actual_title)
    end

    def footer
      @archive.puts @tp.header.to_str(@website.template_vars({ 'page_title' => calculate_title('Archived p/month'),  'title' => 'Archived p/month' }))

      last_year=0
      @pages.sort.reverse.each{|page, generater| 
        if generater.year != last_year
          @archive.puts "</ul>" if last_year != 0

          @archive.puts "<h2>#{generater.year}</h2>"
          @archive.puts "<ul>"

          last_year = generater.year
        end

        @archive.puts(%Q{<li><a href="#{generater.filename}">#{generater.simple_title}</a>})

        @archive.puts('<ul>');

        generater.entries.each{|h|
          @archive.puts <<"HTML"
<li><a href="#{h[:link]}">#{h[:title]}</a></li>
HTML
        }
        
        @archive.puts('</ul></li>');
      }

      @archive.puts "</ul>"

      @archive.puts @tp.footer.to_str(@website.template_vars({ 'title' => 'Archived p/month' }))
      @archive.close
      
      # close all pages.
      @pages.each{ |k, v| v.footer }
    end

    def create_prev_next_links(prev_month, next_month)
      if !prev_month.exists? && !next_month.exists?
        return ''
      elsif !prev_month.exists?
        return next_month.to_str
      elsif !next_month.exists?
        return prev_month.to_str
      else
        return prev_month.to_str + " | " + next_month.to_str
      end
    end

    def item(page)
      unless @pages.has_key?(page.archive_page)
        title = "Archive for #{page.date.strftime('%B %Y')}"

        prev_month = page.prev_month
        next_month = page.next_month

        prev_next_links = <<"HTML"
<div align='center'>#{create_prev_next_links(prev_month, next_month)}</div>
HTML

        @pages[page.archive_page] = Pages::Blog::List.new(@website, @srcdir, @outdir, page.archive_page + '/index.html', 
                                                         { 'title' => title, 
                                                           'simple_title' => page.date.strftime('%B'),
                                                           'year' => page.date.year,
                                                           'menu' => @website.menu_html,
                                                           'prev_next_links' => prev_next_links })
        @pages[page.archive_page].header(title)
      end

      @pages[page.archive_page].item(page)
    end
  end
end
end
