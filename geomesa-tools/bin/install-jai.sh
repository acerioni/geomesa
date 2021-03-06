#! /usr/bin/env bash
#
# Copyright (c) 2013-2016 Commonwealth Computer Research, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0 which
# accompanies this distribution and is available at
# http://www.opensource.org/licenses/apache2.0.php.
#

# Check environment variables before running anything, warn user on issues:
if [[ (-z "$GEOMESA_HOME") ]]; then
    echo "Error: GEOMESA_HOME environmental variable not found...install geomesa or define GEOMESA_HOME and try again"
    exit
else
    osgeo_url='http://download.osgeo.org'
    mvn_url='http://central.maven.org'

    url_codec="${osgeo_url}/webdav/geotools/javax/media/jai_codec/1.1.3/jai_codec-1.1.3.jar"
    url_core="${osgeo_url}/webdav/geotools/javax/media/jai_core/1.1.3/jai_core-1.1.3.jar"
    url_jttools="${mvn_url}/maven2/org/jaitools/jt-utils/1.3.1/jt-utils-1.3.1.jar"
    url_imageio="${osgeo_url}/webdav/geotools/javax/media/jai_imageio/1.1/jai_imageio-1.1.jar"

    NL=$'\n'
    read -r -p "Java Advanced Imaging (jai) is LGPL licensed and is not distributed with GeoMesa...are you sure you want to install the following files:${NL}${url_codec}${NL}${url_core}${NL}${url_jttools}${NL}${url_imageio}${NL}Confirm? [Y/n]" confirm
    confirm=${confirm,,} #lowercasing
    if [[ $confirm =~ ^(yes|y) ]]; then
        echo "Trying to install JAI tools from $url_jttools to $GEOMESA_HOME"
        wget -O $GEOMESA_HOME/lib/common/jt-utils-1.3.1.jar $url_jttools \
            && chmod 0755 $GEOMESA_HOME/lib/common/jt-utils-1.3.1.jar \
            && echo "Successfully installed JAI tools"

        echo "Trying to install JAI ImageIO from $url_imageio to $GEOMESA_HOME"
        wget -O $GEOMESA_HOME/lib/common/jai_imageio-1.1.jar $url_imageio \
            && chmod 0755 $GEOMESA_HOME/lib/common/jai_imageio-1.1.jar \
            && echo "Successfully installed JAI imageio"

        echo "Trying to install JAI Codec from $url_codec to $GEOMESA_HOME"
        wget -O "${GEOMESA_HOME}/lib/common/jai_codec-1.1.3.jar" $url_codec \
            && chmod 0755 "${GEOMESA_HOME}/lib/common/jai_codec-1.1.3.jar" \
            && echo "Successfully installed JAI codec to $GEOMESA_HOME"

        echo "Trying to install JAI Core from $url_core to $GEOMESA_HOME"
        wget -O "${GEOMESA_HOME}/lib/common/jai_core-1.1.3.jar" $url_core \
            && chmod 0755 "${GEOMESA_HOME}/lib/common/jai_core-1.1.3.jar" \
            && echo "Successfully installed JAI core to $GEOMESA_HOME"
    else
        echo "Cancelled installation of Java Advanced Imaging (jai)"
    fi
fi
