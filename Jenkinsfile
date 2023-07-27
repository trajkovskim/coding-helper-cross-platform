
pipeline {
  agent none
  
  environment {
    registry = 'legendmt25/code-help'
  }
  
  stages {
    stage('Build') {
      parallel {
        stage('Core') {
          agent any

          environment {
            tag = ':core-latest'
          }
          
          tools {
            maven 'maven-3.8.1'
            jdk 'jdk-17.0.8'
          }

          steps {
            sh 'mvn package spring-boot:repackage -pl code-help-core'
            script {
              docker.build(registry + tag, './code-help-core')
            }
          }
        }
        stage('Forum') {
          agent any

          environment {
            tag = ':forum-latest'
          }
          
          tools {
            maven 'maven-3.8.1'
            jdk 'jdk-17.0.8'
          }
          
          steps {
            sh 'mvn package -pl code-help-forum'
            script {
              docker.build(registry + tag, './code-help-forum')
            }
          }
        }
      }
    }
  }
}
