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
require 'pages/page'

module Pages
  module Generate

    class Sitemap
      def initialize(website, srcdir, outdir)
        @website = website
        @srcdir = srcdir
        @outdir = outdir

        @out = File.new(outdir + '/sitemap.html', 'w');
        @genpage = GeneratePage.new(website,srcdir,outdir)
      end

      def header
        @genpage.show_header(@out, 'Sitemap')
      end

      def item
        @out.puts "<ul>"
        @website.pages.sort_by {|p| p.title}.each do |page|
          @out.puts "<li><a href='#{page.outfile}'>#{page.title}</a></li>"
        end
        @out.puts "</ul>"
      end

      def footer 
        @genpage.show_footer(@out)
        @out.puts "</body></html>"
        @out.close
      end

      def generate
        puts "Generating sitemap"
        header()
        item()
        footer()
      end

    end
  end
end
