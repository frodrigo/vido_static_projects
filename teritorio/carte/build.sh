#!/bin/bash

set -e

curl http://umap.openstreetmap.fr/fr/datalayer/2395589/ > pois_row.geojson

cat pois_row.geojson | jq '{"type": "FeatureCollection", "features": [
    .features[] | select(.properties.category_ids != null) | .properties += {
        image: [.properties.image],
        metadata: {
            id: .properties.id,
            category_ids: [.properties.category_ids | tonumber]
        },
        editorial: {
            "website:details": .properties.website,
            popup_fields: [
                {field: "description"}
            ]
        }
    } |
    del(.properties[] | nulls)
]}' > pois_tmp.geojson

ruby ../../poi_add_from_menu.rb menu.json pois_tmp.geojson > pois.geojson
