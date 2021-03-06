#!/bin/bash
source ./ci/functions.sh

runBuild=false
echo "Reviewing changes that might affect the Gradle build..."
currentChangeSetAffectsStyle
retval=$?
if [ "$retval" == 0 ]
then
    echo "Found changes that require the build to run static analysis."
    runBuild=true
else
    echo "Changes do NOT affect project static analysis."
    runBuild=false
fi

if [ "$runBuild" = false ]; then
    exit 0
fi

prepCommand="echo 'Running command...'; "
gradle="./gradlew $@"
gradleBuild=""
gradleBuildOptions="--stacktrace --build-cache --configure-on-demand --no-daemon "

echo -e "***********************************************"
echo -e "Gradle build started at `date`"
echo -e "***********************************************"

echo -e "Installing NPM...\n"
./gradlew npmInstall --stacktrace -q

gradleBuild="$gradleBuild check -x test -x javadoc \
     -DskipGradleLint=true -DskipSass=true -DskipNestedConfigMetadataGen=true \
     -DskipNodeModulesCleanUp=true -DskipNpmCache=true --parallel "

if [[ "${TRAVIS_COMMIT_MESSAGE}" == *"[show streams]"* ]]; then
    gradleBuild="$gradleBuild -DshowStandardStreams=true "
fi

if [ -z "$gradleBuild" ]; then
    echo "Gradle build will be ignored since no commands are specified to run."
else
    tasks="$gradle $gradleBuildOptions $gradleBuild"
    echo -e "***************************************************************************************"
    echo $prepCommand
    echo $tasks
    echo -e "***************************************************************************************"

    waitloop="while sleep 9m; do echo -e '\n=====[ Gradle build is still running ]====='; done &"
    eval $waitloop
    waitRetVal=$?

    eval $prepCommand
    eval $tasks
    retVal=$?

    echo -e "***************************************************************************************"
    echo -e "Gradle build finished at `date` with exit code $retVal"
    echo -e "***************************************************************************************"

    if [ $retVal == 0 ]; then
        echo "Gradle build finished successfully."
    else
        echo "Gradle build did NOT finish successfully."
        exit $retVal
    fi
fi
