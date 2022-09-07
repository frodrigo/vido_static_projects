require 'json'

menu = JSON.parse(File.read(ARGV[0])).select{ |m| m['id'] }.to_h{ |m|
  [m['id'], m]
}


pois = JSON.parse(File.read(ARGV[1]))

pois['features'] = pois['features'].collect{ |poi|
  category_ids = poi['properties']['metadata']['category_ids']

  poi['properties']['display'] = poi['properties']['display'] || {}
  poi['properties']['display']['icon'] = menu[category_ids[0]]['category']['icon']
  poi['properties']['display']['color_fill'] = menu[category_ids[0]]['category']['color_fill']
  poi['properties']['display']['color_line'] = menu[category_ids[0]]['category']['color_line']

  poi
}

puts JSON.pretty_generate(pois, indent: '    ')
