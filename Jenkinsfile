pipeline {

    options {
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder( logRotator (
            artifactDaysToKeepStr:'10',
            artifactNumToKeepStr:'5',
            daysToKeepStr:'10',
            numToKeepStr:'5'
        ))
    }

    agent { docker {
        label 'medium'
        image 'docker.seal-software.net/build-agent'
        args dockerArgs('--network="host"')
    }}

    environment {
        VERSION = "8.7-SNAPSHOT_SEAL-${env.BUILD_NUMBER}"
    }

    stages {

        stage('setup') {
          steps {
          // Do any setup here
          sh 'mvn -B versions:set -DnewVersion=$VERSION -DgenerateBackupPoms=false'
        }}

        stage('build') {
          steps {
            // Services should not have to deploy anything
            // to maven repos, since the only thing needed downstream
            // is the installer jar
            sh 'mvn --version'
            sh "mvn -B -e -T4 clean install"
          }
          post { always {
            // Show test results in jenkins ui
            junit 'target/surefire-reports/**/*.xml'
          }}
        }

        stage('deploy') {
            steps {
                sh("mvn -B -Prelease -e deploy -Dmaven.test.skip=true")
            }
        }

    }

    post {
       always {
           cleanWs()
       }
    }
}
