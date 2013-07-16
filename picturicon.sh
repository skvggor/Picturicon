#!/bin/bash

layer1=$1;
layer2=$2;
margin_bottom=$3;
margin_right=$4;
output_file=$5;

if ! [[ $margin_bottom && $margin_right ]]; then
  output_file=$3;
  margin_bottom=0;
  margin_right=0;
fi

add_icon () {
  RED="\033[01;31m";
  WHITE="\033[00;00m";
  GREEN="\033[00;92m";

  if [[ $layer1 && $layer2 && $output_file ]]; then
    width=`identify -format %w $layer1`;
    height=`identify -format %h $layer1`;
    icon_width=`identify -format %w $layer2`;
    icon_height=`identify -format %h $layer2`;
    resolution=`expr $width \\* $height`;
    icon_resolution=`expr $icon_width \\* $icon_height`;

    if [[ $resolution -gt $icon_resolution ]]; then
      if ! [[ -a $output_file ]]; then
        status=${GREEN};
        convert -monitor $layer1 \
                -page +$((width-(icon_width+margin_bottom)))+$((height-(icon_height+margin_right))) $layer2 \
                -layers merge $output_file;
        echo -e "$status Picturicon: Processing completed successfully.";
      else
        status=${RED};
        echo -e "$status Picturicon: The ${GREEN}$output_file ${status}file already exists.";
      fi
    else
      status=${RED};
      echo -e "$status Picturicon: The avatar is smaller than the icon! Restart processing.";
    fi
  else
    status=${RED};
    echo -e "$status Picturicon: Missing file (s) to process. Restart processing.";
  fi
}

initializer() {
  add_icon;
}

initializer;