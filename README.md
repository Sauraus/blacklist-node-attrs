DESCRIPTION
==============
Allows you to provide a blacklist of node attributes to not save on the server. All
of the attributes are still available throughout the chef run, but those specifically
listed will not be saved to the server.

ATTRIBUTES
==============
node[:blacklist] provides a map of node attributes not to store. The defaults are provided
by this cookbook, and the map is:

    node.default[:whitelist] = {
      "password" => true,
      "private_key" => true
    }

The results would be that the node object as seen on the server will not have the attributes specified above.

This cookbook honors the fact that attributes are set at different precedence levels.

USAGE
==============
Upload the cookbook, and make sure that it is included as a dependency in another cookbooks
metadata, or that the recipe (which does nothing) is included in the role.

Whenever node.save is called, the blacklist will be applied.
