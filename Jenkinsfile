pipeline {
    agent any

    environment {
        APP_NAME = "springboot-demo"
        DOCKER_IMAGE = "dockerhub_username/springboot-demo"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        K8S_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/chetashree10/gs-spring-boot.git'
            }
        }

        stage('Build & Unit Test') {
            steps {
                dir('app/sample-spring-boot-app') {
                    sh 'mvn clean test package'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app/sample-spring-boot-app') {
                    sh 'docker build -t $DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS_ID,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                sh '''
                kubectl apply -f k8s/dev/
                kubectl rollout status deployment/springboot-app -n dev
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
