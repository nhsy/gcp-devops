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
                sh "docker build --rm --no-cache --build-arg TERRAFORM_VERSION=0.12.29 --tag $REGISTRY/$IMAGE:0.12 ."
                sh "docker build --rm --no-cache --build-arg TERRAFORM_VERSION=0.13.5 --tag $REGISTRY/$IMAGE:0.13 ."
                sh "docker build --rm --no-cache --build-arg TERRAFORM_VERSION=0.14.2 --tag $REGISTRY/$IMAGE:0.14 ."                
            }
        }
        stage("Push") {
            when {
                branch 'master'
            }
            steps {
                withDockerRegistry([ credentialsId: 'dockerhub', url: '' ]) {
                    sh "echo docker push $REGISTRY/$IMAGE:latest"
                    sh "docker push $REGISTRY/$IMAGE:0.12"
                    sh "docker push $REGISTRY/$IMAGE:0.13"
                    sh "docker push $REGISTRY/$IMAGE:0.14"

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
