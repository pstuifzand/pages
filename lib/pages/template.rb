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
class Template
  def initialize(templatefile)
    if File.exists?(templatefile)
      File.open(templatefile) do |file|
        @content = file.read
      end
    else
      @content = false
    end
  end

  def to_str(values=Hash.new(''))
    return '' unless @content

    str = @content.dup

    str.gsub!(/\[%\s*(\w+)\s*%\]/) {|match|
      values[$1] || ''
    }

#    values.each {|k,v|
#      str.gsub!(/\[%\s*#{k}\s*%\]/x, v)
#    }

    return str
    
  end

  def exists?
    return !!@content
  end
end

class TemplatePage
  attr_reader :header, :footer, :header_file, :footer_file, 
    :post_header, :post_footer, :post_header_file, :post_footer_file

  def initialize(srcdir)
    @header_file = srcdir + "/header.tpf"
    @footer_file = srcdir + "/footer.tpf"

    @post_header_file = srcdir + "/post-header.tpf"
    @post_footer_file = srcdir + "/post-footer.tpf"

    @header = Pages::Template.new(@header_file)
    @footer = Pages::Template.new(@footer_file)

    @post_header = Pages::Template.new(@post_header_file)
    @post_footer = Pages::Template.new(@post_footer_file)

  end
end

end
