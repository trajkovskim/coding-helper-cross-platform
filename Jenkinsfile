def versionCore
def versionForum

pipeline {
  agent none
  
  environment {
    library = 'legendmt25/code-help'
    dockerRegistry = 'https://registry.hub.docker.com'
    dockerCredentialsId = 'dockerhub'
    gitCredentialsId = 'github'
  }
  
  stages {
    // stage('mvn clean package') {
    //   parallel {
    //     stage('Core') {
    //       agent any
          
    //       tools {
    //         maven 'maven-3.8.1'
    //         jdk 'jdk-17.0.8'
    //       }

    //       steps {
    //         sh 'mvn clean package -f code-help-core'
    //       }
    //     }
    //     stage('Forum') {
    //       agent any
          
    //       tools {
    //         maven 'maven-3.8.1'
    //         jdk 'jdk-17.0.8'
    //       }
          
    //       steps {
    //         sh 'mvn clean package -f code-help-forum'
    //       }
    //     }
    //   }
    // }
    // stage('Docker build and push') {
    //   parallel {
    //     stage('Core') {
    //       agent any

    //       environment {
    //         tag = 'core-'
    //         projectPath = './code-help-core'
    //       }

    //       steps {
    //         script {
    //           versionCore = sh (
    //             script: "grep version ${projectPath}/code-help-core-app/target/maven-archiver/pom.properties | cut -d'=' -f 2",
    //             returnStdout: true)
    //           .trim()
    //           coreImage = docker.build("${library}:${tag}${versionCore}", "--build-arg VERSION=${versionCore} ${projectPath}")
    //           docker.withRegistry(dockerRegistry, dockerCredentialsId) {
    //             coreImage.push()
    //             coreImage.push("${tag}latest")
    //           }
    //         }
    //       }
    //     }
    //     stage('Forum') {
    //       agent any

    //       environment {
    //         tag = 'forum-'
    //         projectPath = './code-help-forum'
    //       }
          
    //       steps {
    //         script {
    //           versionForum = sh (
    //             script: "grep version ${projectPath}/target/maven-archiver/pom.properties | cut -d'=' -f 2",
    //             returnStdout: true)
    //           .trim()
    //           forumImage = docker.build("${library}:${tag}${versionForum}", "--build-arg VERSION=${versionForum} ${projectPath}")
    //           docker.withRegistry(dockerRegistry, dockerCredentialsId) {
    //             forumImage.push()
    //             forumImage.push("${tag}latest")
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    stage('GitOps: Update manifests') {
      agent any

      environment {
        gitRepo = 'https://github.com/legendmt25/kiii-195063.git'
        basePath = './app'
      }

      steps {
        dir('kiii-195063') {
          git(url: gitRepo, credentialsId: gitCredentialsId, branch: 'main')
          sh "sed -i 's/legendmt25\\/code-help:core.*/legendmt25\\/code-help:core-${versionCore}/g' ${basePath}/core/deploy.yaml"
          sh "sed -i 's/legendmt25\\/code-help:forum.*/legendmt25\\/code-help:forum-${versionCore}/g' ${basePath}/forum/deploy.yaml"
          sh "git config user.email 195063@ci.com"
          sh "git config user.name 195063-ci"
          sh "git add ."
          sh "git commit -m '[195063-ci] Update core image version to: ${versionCore} and forum image version to ${versionForum}'"
          sh "cat ${basePath}/core/deploy.yaml"
          sh "cat ${basePath}/forum/deploy.yaml"
          sh "git push -uf origin main"
        }
      }
    }
  }
}
