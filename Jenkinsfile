

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
            tag = 'core-'
            projectPath = './code-help-core'
            version = sh (
              script: 'grep version ./code-help-core/code-help-core-app/target/maven-archiver/pom.properties | cut -d"=" -f 2',
              returnStdout: true)
            .trim()
          }

          steps {
            script {
              coreImage = docker.build('${library}:${tag}${version}', '--build-arg VERSION=${version} ${projectPath}')
              docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                coreImage.push()
                coreImage.push('${tag}latest')
              }
            }
          }
        }
        stage('Forum') {
          agent any

          environment {
            tag = 'forum-'
            projectPath = './code-help-forum'
            version = sh (
              script: 'grep version ./code-help-forum/target/maven-archiver/pom.properties | cut -d"=" -f 2',
              returnStdout: true)
            .trim()
          }
          
          steps {    
            script {
              forumImage = docker.build('${library}:${tag}${version}', '--build-arg VERSION=${version} ${projectPath}')
              docker.withRegistry(dockerRegistry, dockerCredentialsId) {
                forumImage.push()
                forumImage.push('${tag}latest')
              }
            }
          }
        }
      }
    }
  }
}
