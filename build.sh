#!/bin/bash

set -e

mkdir -p dest

find */* -name build.sh | while read build; do
    DIR=$(dirname $build)
    mkdir -p "dest/$DIR"

    cd "$DIR"
    bash build.sh
    cp -r settings.json menu.json pois.geojson articles.json attribute_translations "../../dest/$DIR"
    cd -

    ruby poi_explode.rb "dest/$DIR/pois.geojson"
done
