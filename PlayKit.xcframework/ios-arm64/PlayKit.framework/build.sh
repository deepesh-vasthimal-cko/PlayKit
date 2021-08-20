#! /bin/sh -e
# Output Path
set -x

OUTPUT_DIR_PATH="OutputFolder"
# Xcode Project Name
PROJECT_NAME="PlayKit"

if [[ -z OUTPUT_DIR_PATH ]]; then
echo "❌Output dir was not set. try to run ./build.sh Build"
exit 1;
fi
if [[ -z PROJECT_NAME ]]; then
echo "❌Project name was not set. try to run ./build.sh Build Project"
exit 1;
fi
# Prints the archive path for simulator
function archivePathSimulator {
local DIR=${OUTPUT_DIR_PATH}/archives/"${1}-SIMULATOR"
echo "${DIR}"
}
# Prints the archive path for device
function archivePathDevice {
local DIR=${OUTPUT_DIR_PATH}/archives/"${1}-DEVICE"
echo "${DIR}"
}
# Archive takes 3 params
#
# 1st == SCHEME
# 2nd == destination
# 3rd == archivePath
function archive {
echo "📨 Starts archiving the scheme: ${1} for destination: ${2};\n📝 Archive path: ${3}.xcarchive"
xcodebuild archive \
-workspace ${PROJECT_NAME}.xcworkspace \
-scheme ${1} \
-destination "${2}" \
-configuration Release \
-archivePath "${3}" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
}
# Builds archive for iOS/tvOS simulator & device
function buildArchive {

SCHEME=${1}
archive $SCHEME "generic/platform=iOS Simulator" $(archivePathSimulator $SCHEME)
archive $SCHEME "generic/platform=iOS" $(archivePathDevice $SCHEME)
}
# Creates xc framework
function createXCFramework {
FRAMEWORK_ARCHIVE_PATH_POSTFIX=".xcarchive/Products/Library/Frameworks"
FRAMEWORK_SIMULATOR_DIR="$(archivePathSimulator $1)${FRAMEWORK_ARCHIVE_PATH_POSTFIX}"
FRAMEWORK_DEVICE_DIR="$(archivePathDevice $1)${FRAMEWORK_ARCHIVE_PATH_POSTFIX}"

xcodebuild -create-xcframework \
-framework ${FRAMEWORK_SIMULATOR_DIR}/${1}.framework \
-framework ${FRAMEWORK_DEVICE_DIR}/${1}.framework \
-output ${OUTPUT_DIR_PATH}/xcframeworks/${1}.xcframework

if [[ $? == 0 ]]; then
    echo "Build Success"
else
    echo "Build Failed exit here"
    exit 1
fi

}

echo "🚀 Process started 🚀"
echo "📂 Evaluating Output Dir"
echo "🧼 Cleaning the dir: ${OUTPUT_DIR_PATH}"
rm -rf $OUTPUT_DIR_PATH
DYNAMIC_FRAMEWORK="PlayKit"
echo "📝 Archive $DYNAMIC_FRAMEWORK"
buildArchive ${DYNAMIC_FRAMEWORK}
echo "🗜 Create $DYNAMIC_FRAMEWORK.xcframework"
createXCFramework ${DYNAMIC_FRAMEWORK}
mv ${OUTPUT_DIR_PATH}/xcframeworks/${DYNAMIC_FRAMEWORK}.xcframework ${OUTPUT_DIR_PATH}/${DYNAMIC_FRAMEWORK}.xcframework

