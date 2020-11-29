pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    triggers {
        cron('@weekly')
    }
    environment {
        IMAGE = 'gcp-devops'
        REGISTRY = 'dizzyplan'
    }

    stages {
        stage("Build") {
            steps {
                sh "docker build --rm --no-cache --tag $REGISTRY/$IMAGE:latest --tag $REGISTRY/$IMAGE:0.13 ."
                sh "docker build --rm --no-cache --build-arg TERRAFORM_VERSION=0.12.29 --tag $REGISTRY/$IMAGE:0.12 ."                
            }
        }
        stage("Push") {
            when {
                branch 'master'
            }
            steps {
                withDockerRegistry([ credentialsId: 'dockerhub', url: '' ]) {
                    sh "docker push $REGISTRY/$IMAGE:$TAG"
                    sh "docker push $REGISTRY/$IMAGE:0.13"
                    sh "docker push $REGISTRY/$IMAGE:0.12"

                }
            }
        }
    }

    post {
        success {
            sh "docker image prune --filter=\"label=name=\$IMAGE\" -f"
            sh "docker image prune --filter=\"label=name=\$REGISTRY/\$IMAGE\" -f"
        }
        always {
            deleteDir()
        }
    }
}
