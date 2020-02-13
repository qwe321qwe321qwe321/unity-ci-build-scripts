#!/usr/bin/env bash

set -e #This means Exit immediately if a command exits with a non-zero status in any below codes.
#set -x #This means echo everything you wrote.

echo "Building for $BUILD_TARGET"

export BUILD_PATH=/root/project/${PROJECT_PATH}Builds/$BUILD_TARGET/
mkdir -p $BUILD_PATH

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath $PROJECT_PATH \
  -quit \
  -batchmode \
  -buildTarget $BUILD_TARGET \
  -customBuildTarget $BUILD_TARGET \
  -customBuildName $BUILD_NAME \
  -customBuildPath $BUILD_PATH \
  -customBuildOptions AcceptExternalModificationsToPlayer \
  -executeMethod BuildCommand.PerformBuild \
  -logFile

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "///////////////////////////////////////////"
  echo "/// Run succeeded, no failures occurred ///"
  echo "///////////////////////////////////////////"
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "///////////////////////////////////////////"
  echo "/// Run succeeded, some tests failed //////"
  echo "///////////////////////////////////////////"
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "///////////////////////////////////////////"
  echo "////// Run failure (other failure) ////////"
  echo "///////////////////////////////////////////"
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

[ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
exit $UNITY_EXIT_CODE
