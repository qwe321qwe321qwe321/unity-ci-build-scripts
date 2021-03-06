#!/usr/bin/env bash

#set -x #This means echo everything you wrote.

echo "Testng for $TEST_PLATFORM"

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath $PROJECT_PATH \
  -runTests \
  -testPlatform $TEST_PLATFORM \
  -testResults /root/project/${PROJECT_PATH}TestResults.xml \
  -logFile \
  -batchmode

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "///////////////////////////////////////////"
  echo "/// Run succeeded, no failures occurred ///"
  echo "///////////////////////////////////////////"
  cat /root/project/${PROJECT_PATH}TestResults.xml | grep test-run | grep Passed
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "///////////////////////////////////////////"
  echo "/// Run succeeded, some tests failed //////"
  echo "///////////////////////////////////////////"
  cat /root/project/${PROJECT_PATH}TestResults.xml
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "///////////////////////////////////////////"
  echo "////// Run failure (other failure) ////////"
  echo "///////////////////////////////////////////"
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

exit $UNITY_EXIT_CODE