pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        IMAGE = 'gcp-devops'
        TAG = 'latest'
    }

    stages {
        stage("Build") {
           steps {
              sh "docker build --rm --no-cache --tag \$IMAGE:\$TAG ."
           }
        }
    }

    post {
        success {
            sh "docker image prune --filter=\"label=name=\$IMAGE\" -f"
        }
    }
}
