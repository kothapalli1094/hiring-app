pipeline {
    agent any

    tools {
        maven 'mvn3'
        jdk 'jdk17'
    }

    environment {
        IMAGE_NAME = "shivasrk/shivasrk-argocd"
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = "docker-cred"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '🔁 Checking out code from GitHub...'
                git branch: 'main',
                    credentialsId: 'git-cred',
                    url: 'https://github.com/kothapalli1094/hiring-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                echo '🏗️ Building WAR package...'
                sh '''
                    mvn clean package -DskipTests
                    mv target/hiring.war target/shiva-app.war
                '''
            }
        }

        stage('Verify WAR File') {
            steps {
                sh 'ls -l target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            when {
                expression { return env.DOCKER_CREDENTIALS != null }
            }
            steps {
                echo '📤 Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", usernameVariable: "DOCKER_USER", passwordVariable: "DOCKER_PASS")]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Docker image build and push completed successfully!'
        }
        failure {
            echo '❌ Docker image build failed — check the console logs.'
        }
    }
}
