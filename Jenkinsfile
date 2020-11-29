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
        TAG = 'latest'
        REGISTRY = 'dizzyplan'
    }

    stages {
        stage("Build") {
            steps {
                //sh "docker build --rm --no-cache --tag $IMAGE:$TAG --tag $REGISTRY/$IMAGE:$TAG ."
                sh "docker build --rm --no-cache --tag $IMAGE:$TAG --tag $REGISTRY/$IMAGE:$TAG ."
                sh "docker build --rm --no-cache --tag $IMAGE:0.13 --tag $REGISTRY/$IMAGE:0.13 ."
                sh "docker build --rm --no-cache --build-arg TERRAFORM_VERSION=0.12.29 --tag $IMAGE:0.12 --tag $REGISTRY/$IMAGE:0.12 ."
                
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
    }
}
