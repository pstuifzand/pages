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
module Storage
 
class Month
  def initialize(exists, date, forward)
    @date = date
    @forward = forward
    @exists = exists
  end

  def exists?
    return @exists
  end

  def to_str
    if exists?
      return "<a href='#{@date.strftime('%Y%m')}.html'>#{!@forward ? '&laquo;' : ''} #{@date.strftime('%B %Y')} #{@forward ? '&raquo;' : ''}</a>"
    else
      raise "no page for month #{@date.strftime('%B %Y')}"
    end
  end
end



end
end
