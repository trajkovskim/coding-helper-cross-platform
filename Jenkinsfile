
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

          environment {
            tag = ':core-latest'
          }
          
          tools {
            maven 'maven-3.8.1'
            jdk 'jdk-17.0.8'
          }

          steps {
            sh 'mvn clean package -f code-help-core'
            script {
              docker.build(registry + tag, './code-help-core').push()
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
            sh 'mvn clean package -f code-help-forum'
            script {
              docker.build(registry + tag, './code-help-forum').push()
            }
          }
        }
      }
    }
  }
}
