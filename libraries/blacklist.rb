#
# Author:: Antek Baranski (<antek.baranski@gmail.com>)
# Copyright:: Copyright (c) 2014 Antek Baranski
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Blacklist
  # filter takes two arguments - the data you want to filter, and a
  # blacklisted map of the keys you want excluded. Note we are only using the
  # keys in this hash - if the values are anything other than another hash, we
  # ignore them.
  #
  # Blacklist.filter(
  # { "filesystem" => {
  #    "/dev/disk0s2" => {
  #     "size" => "10mb"
  #    },
  #    "map - autohome' => {
  #     "size" => "10mb"
  #    }
  # },
  # {
  #   "filesystem" => {
  #     "/dev/disk0s2" => true
  #   }
  # })
  #
  # Will drop the entire "map - autohome" tree.
  def self.filter(data, blacklist)
    if data == nil
      return nil
    end

    new_data = data.reject { |key, value| blacklist.keys.include?(key) }
    blacklist.each do |k,v|
      if v.kind_of?(Hash)
        new_data[k] = filter(new_data[k], v)
      end
    end
    new_data
  end
end

class Chef
  class Node
    alias_method :old_save, :save

    def save
      Chef::Log.info("Blacklisting node attributes")
      blacklist = self[:blacklist].to_hash
      self.default_attrs = Blacklist.filter(self.default_attrs, blacklist)
      self.normal_attrs = Blacklist.filter(self.normal_attrs, blacklist)
      self.override_attrs = Blacklist.filter(self.override_attrs, blacklist)
      self.automatic_attrs = Blacklist.filter(self.automatic_attrs, blacklist)
      old_save
    end
  end
end
