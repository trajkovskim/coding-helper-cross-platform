

pipeline {
  agent none
  
  environment {
    library = 'legendmt25/code-help'
    dockerRegistry = 'https://hub.docker.com'
    dockerCredentialsId = 'dockerhub'
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
              docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                image.push()
              }
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
              docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                image.push()
              }
            }
          }
        }
      }
    }
  }
}
