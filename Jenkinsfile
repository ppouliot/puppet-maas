def SUFFIX = ''

pipeline {
    agent any

    parameters {
        string (name: 'VERSION_PREFIX', defaultValue: '0.0.0', description: 'puppet-dns version')
    }
    environment {
        BUILD_TAG = "${env.BUILD_TAG}".replaceAll('%2F','_')
        BRANCH = "${env.BRANCH_NAME}".replaceAll('/','_')
        BEAKER_PUPPET_COLLECTION = "puppet6"
        BEAKER_PUPPET_VERSION = "6"
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }
    stages {
        stage ('Use the Puppet Development Bundle Install to install missing gem dependencies') {
            steps {
                sh 'pdk bundle install 2> /dev/null'
            }
        }

        stage ('Use the Puppet Development Kit Validation to Check for Linting Errors') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk validate'
            }
        }

        stage ('UNIT TESTS: Use the Puppet Development Kit Test Unit for Module Unit Testing') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk test -d unit'
            }
        }
        stage ('UNIT TESTS: Use the Puppet Development Kit To run Rake/Rspec Unit Tests for full visibility') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                sh 'pdk bundle exec rake spec'
            }
        }
        stage ('DOCKER SMOKE TESTS: Checkout and build puppet-maas in Docker to validate code as well as changes across OSes using build.sh script') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                dir("${env.WORKSPACE}") {
                    sh './build.sh -d'
                }
            } 
        }

        stage ('VAGRANT SMOKE TESTS: Checkout and build puppet-maas in Vagrant to assemble a functional MAAS Server'/ {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                dir("${env.WORKSPACE}") {

                    sh './build.sh -v'
                }
            } 
        }
        
        stage ('VAGRANT SMOKE TESTS CLEANUP: Cleanup vagrant after successful build.') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'vagrant destroy -f'
            }
        }

// Comment Out  Acceptance tests until they are working
/*

        stage ('ACCEPTANCE TESTS: Use the Puppet Development Kit To run Beaker Acceptance Tests') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk bundle exec rake beaker:default'
            }
        }
*/
 
        stage ('Cleanup Acceptance Tests after successful build, and prepare for release.') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'pdk bundle exec rake module:clean'
            }
        }

// Comment Out until we figure best workflow
/*
        stage ('Build Puppet module files') {
            steps {
                sh 'pdk bundle exec rake build:pdk'
            }
        }

        stage ('Tag puppet module files') {
            steps {
                sh 'pdk bundle exec rake module:tag'
            }
        }

        stage ('Push puppet module files') {
            steps {
                sh 'pdk bundle exec rake module:push'
            }
        }

        stage ('Bump version and Commit puppet module files') {
            steps {
                sh 'pdk bundle exec rake module:bump_commit'
            }
        }

        stage ('Code signing') {
            steps {
                sh 'echo "Do we need to add Code Signing for puppet modules?"'
            }
        }

        stage ('Upload to GitHub') {
            steps {
                sh 'git push origin'
            }
        }
*/
        stage ('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

    } 
}
