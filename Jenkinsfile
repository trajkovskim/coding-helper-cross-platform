

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
          }

          steps {
            script {
              version = sh (
                script: 'grep version ${projectPath}/code-help-core-app/target/maven-archiver/pom.properties | cut -d"=" -f 2',
                returnStdout: true)
              .trim()
              dockerBuildArgs = '--build-arg VERSION=${version}'
              dockerImageNameTag = '${library}:${tag}${version}'
              
              coreImage = docker.build(dockerImageNameTag, '${dockerBuildArgs} ${projectPath}')
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
            projectPath = './code-help-core'
          }
          
          steps {    
            script {
              version = sh (
                script: 'grep version ./code-help-forum/target/maven-archiver/pom.properties | cut -d"=" -f 2',
                returnStdout: true)
              .trim()
              dockerBuildArgs = '--build-arg VERSION=${version}'
              dockerImageNameTag = '${library}:${tag}${version}'
              
              forumImage = docker.build(dockerImageNameTag, '${dockerBuildArgs} ${projectPath}')
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
