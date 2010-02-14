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
module Pages
  module Layout

    def calculate_title(title)
      pagetitle = @website.title
      pagetitle += ': ' + title if title.length > 0
      return pagetitle
    end

    def title_with_website_at_end(title)
      pagetitle = ''
      pagetitle += title if title.length > 0
      pagetitle += ' - ' + website.title
      return pagetitle
    end

    def show_header(out, title)
      pagetitle = calculate_title(title)

      css_file = @website.css_file

      return ''
    end

    def show_footer(out)
      return ''
    end
  end
end
