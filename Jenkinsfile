

pipeline {
  agent none
  
  environment {
    library = 'legendmt25/code-help'
    dockerRegistry = 'https://registry.hub.docker.com'
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
            tag = ':core-'
          }

          steps {
            version = sh (
              script: 'grep version ./code-help-core/code-help-core-app/target/maven-archiver/pom.properties | cut -d'=' -f 2',
              returnStdout: true)
            .trim()
            script {
              image = docker.build(library + tag, '--build-arg VERSION=' + version + ' ./code-help-core')
              docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                image.push()
              }
            }
          }
        }
        stage('Forum') {
          agent any

          environment {
            tag = ':forum-'
          }
          
          steps {
            version = sh (
              script: 'grep version ./code-help-forum/target/maven-archiver/pom.properties | cut -d'=' -f 2',
              returnStdout: true)
            .trim()
            
            script {
              image = docker.build(library + tag, '--build-arg VERSION=' + version + ' ./code-help-forum')
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
