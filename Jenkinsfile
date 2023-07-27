
pipeline {
  agent none
  
  environment {
    registry = 'legendmt25/code-help'
  }
  
  stages {
    stage('Build and push') {
      parallel {
        stage('Core') {
          agent any
          
          tools {
            maven 'maven-3.8.1'
            jdk 'jdk-17.0.8'
          }

          steps {
            sh 'mvn clean package -f code-help-core'
          }
        }
        stage('Forum') {
          agent any
          
          tools {
            maven 'maven-3.8.1'
            jdk 'jdk-17.0.8'
          }
          
          steps {
            sh 'mvn clean package -f code-help-forum'
          }
        }
      }
    }
    stage('Docker build and push') {
      parallel {
        stage('Core') {
          agent any

          environment {
            tag = ':core-latest'
          }

          steps {
            script {
              image = docker.build(registry + tag, './code-help-core')
              image.push()
            }
          }
        }
        stage('Forum') {
          agent any

          environment {
            tag = ':forum-latest'
          }
          
          steps {
            script {
              image = docker.build(registry + tag, './code-help-forum')
              image.push()
            }
          }
        }
      }
    }
  }
}
