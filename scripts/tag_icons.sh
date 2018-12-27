# Overlay the build version and the git hash on the app icon
#
# Inspired by @merowing and @bejo script
# who were inspired initially by Evan Doll's talk
#
# http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/#.VCg9li5_v6A
# https://github.com/bejo/XcodeIconTagger/blob/master/tagIcons.sh

version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${INFOPLIST_FILE}"`

# script subcommands
mode=$1
tagMode="tag"
cleanupMode="cleanup"

function processIcon() {
  export PATH=$PATH:/usr/local/bin:/opt/boxen/homebrew/bin/
  icon_path=$1

  width=`identify -format %w ${icon_path}`
  
  convert -background '#0008' -fill white -gravity center -size ${width}x40\
  caption:"${version}"\
  ${icon_path} +swap -gravity south -composite ${icon_path}
  echo "Icon '$icon_path' updated"
}

# retrieve the icon list from the assets catalogue
iconsDirectory=`cd $2 && pwd`
if [ $(echo "${iconsDirectory}" | grep -E "\.appiconset$") ]; then
  icons=(`grep 'filename' "${iconsDirectory}/Contents.json" | cut -f2 -d: | tr -d ',' | tr -d '\n' | tr -d '"'`)
fi

iconsCount=${#icons[*]}
for (( i=0; i<iconsCount; i++ ))
do
  icon="$iconsDirectory/${icons[$i]}"

  if [ -f $icon ]; then
    if [ $mode == $tagMode ]; then            
      # ensure the icon hasn't been already tagged
      git checkout $icon
      # tag it
      processIcon $icon
    elif [ $mode == $cleanupMode ]; then
      git checkout $icon
    else
      echo " ! Unknown mode `$mode`"
    fi
  else 
    echo " ! No icon for path `$icon`" 
  fi
done