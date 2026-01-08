pipeline {
    agent any

    environment {
        IMAGE_NAME = "chetu20/springboot-complete"
        IMAGE_TAG  = "latest"
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/chetashree10/app.git'
            }
        }

        stage('Build Application (Maven)') {
            steps {
                dir('app_code/complete') {
                    sh '''
                    mvn clean package -DskipTests
                    ls -l target
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app_code/complete') {
                    sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                sh '''
                echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                sh '''
                kubectl get nodes

                kubectl apply -f app/k8s/dev/namespace.yaml || true
                kubectl apply -n dev -f app/k8s/dev/configmap.yaml
                kubectl apply -n dev -f app/k8s/dev/deployment.yaml
                kubectl apply -n dev -f app/k8s/dev/service.yaml

                kubectl rollout status deployment/springboot-complete -n dev
                kubectl get pods -n dev
                kubectl get svc -n dev
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
