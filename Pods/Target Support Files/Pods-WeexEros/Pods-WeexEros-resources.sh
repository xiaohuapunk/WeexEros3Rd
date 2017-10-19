#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\""
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH"
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "AMap3DMap-NO-IDFA/MAMapKit.framework/AMap.bundle"
  install_resource "AMapNavi-NO-IDFA/AMapNaviKit.framework/AMapNavi.bundle"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/ATSDK.bundle"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/en.lproj"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/zh-Hans.lproj"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarLeftArrows@2x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarLeftArrows@3x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarReightArrows@2x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarReightArrows@3x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Chart/Resources/bm-chart.html"
  install_resource "../Benmu-iOS-Library/BMComponent/Chart/Resources/echarts.min.js"
  install_resource "../Benmu-iOS-Library/BMController/Resources/decrease@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/endPoint@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/endPoint@3.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/gpsStat1@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/increase@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/navIcon@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/navIcon@3x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/startPoint@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/startPoint@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionFontSize@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionFontSize@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionIcon@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionIcon@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/feedback@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/feedback@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_icon@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_icon@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_pasteboard@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_pasteboard@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatSession@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatSession@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatTimeLine@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatTimeLine@3x.png"
  install_resource "../Benmu-iOS-Library/BMWeexExtension/Resources/bm-base.js"
  install_resource "../Benmu-iOS-Library/BMWeexExtension/Resources/arrowInKeyboard@2x.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin@2x.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin@3x.png"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
  install_resource "TZImagePickerController/TZImagePickerController/TZImagePickerController/TZImagePickerController.bundle"
  install_resource "UMengUShare/UShareSDK/UMSocialSDK/UMSocialSDKPromptResources.bundle"
  install_resource "../WeexiOSSDK/WeexSDK/Resources/native-bundle-main.js"
  install_resource "../WeexiOSSDK/WeexSDK/Resources/wx_load_error@3x.png"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "AMap3DMap-NO-IDFA/MAMapKit.framework/AMap.bundle"
  install_resource "AMapNavi-NO-IDFA/AMapNaviKit.framework/AMapNavi.bundle"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/ATSDK.bundle"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/en.lproj"
  install_resource "ATSDK-Weex/ATSDK.framework/Versions/A/Resources/zh-Hans.lproj"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarLeftArrows@2x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarLeftArrows@3x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarReightArrows@2x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Calendar/Resources/CalendarReightArrows@3x.png"
  install_resource "../Benmu-iOS-Library/BMComponent/Chart/Resources/bm-chart.html"
  install_resource "../Benmu-iOS-Library/BMComponent/Chart/Resources/echarts.min.js"
  install_resource "../Benmu-iOS-Library/BMController/Resources/decrease@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/endPoint@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/endPoint@3.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/gpsStat1@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/increase@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/navIcon@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/navIcon@3x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/startPoint@2x.png"
  install_resource "../Benmu-iOS-Library/BMController/Resources/startPoint@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionFontSize@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionFontSize@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionIcon@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/actionIcon@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/feedback@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/feedback@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_icon@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_icon@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_pasteboard@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_pasteboard@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatSession@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatSession@3x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatTimeLine@2x.png"
  install_resource "../Benmu-iOS-Library/BMManager/Resources/share_wechatTimeLine@3x.png"
  install_resource "../Benmu-iOS-Library/BMWeexExtension/Resources/bm-base.js"
  install_resource "../Benmu-iOS-Library/BMWeexExtension/Resources/arrowInKeyboard@2x.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin@2x.png"
  install_resource "../Benmu-iOS-Library/Weexplugin/Resources/greenPin@3x.png"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
  install_resource "TZImagePickerController/TZImagePickerController/TZImagePickerController/TZImagePickerController.bundle"
  install_resource "UMengUShare/UShareSDK/UMSocialSDK/UMSocialSDKPromptResources.bundle"
  install_resource "../WeexiOSSDK/WeexSDK/Resources/native-bundle-main.js"
  install_resource "../WeexiOSSDK/WeexSDK/Resources/wx_load_error@3x.png"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
