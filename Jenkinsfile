// Example of Jenkins pipeline script

pipeline {
    agent {
        any
    }

    environment {
        IMAGE = 'gcp-devops'
        TAG = 'latest'

    }

    stages {
        stage("build") {
           steps {
              sh "env"
           }
        }
/*
    post {
      success {
        withCredentials([usernamePassword(credentialsId: 'github-nhsy-cloudbees', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'curl -X POST --user $USERNAME:$PASSWORD --data  "{\\"state\\": \\"success\\", \\"target_url\\": \\"${BUILD_URL}\\"}" --url $GITHUB_API_URL/statuses/$GIT_COMMIT'
        }
      }
      failure {
        withCredentials([usernamePassword(credentialsId: 'github-nhsy-cloudbees', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'curl -X POST --user $USERNAME:$PASSWORD --data  "{\\"state\\": \\"failure\\", \\"target_url\\": \\"${BUILD_URL}\\"}" --url $GITHUB_API_URL/statuses/$GIT_COMMIT'
        }
      }
    }
*/
}
