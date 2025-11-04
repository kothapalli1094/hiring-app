pipeline {
    agent any

    tools {
        maven 'mvn3'
        jdk 'jdk17'
    }

    environment {
        IMAGE_NAME = "shivasrk/shivasrk-argocd"     // 🔹 Your Docker Hub repo
        IMAGE_TAG = "${BUILD_NUMBER}"               // 🔹 Build tag
        DOCKER_CREDENTIALS = "docker-cred"          // 🔹 Docker credentials ID
        CONTAINER_NAME = "shiva-app"                // 🔹 Local container name
        APP_PORT = "8080"                           // 🔹 Host port
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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify WAR File') {
            steps {
                echo '📂 Verifying WAR artifact...'
                sh 'ls -l target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh '''
                    export DOCKER_BUILDKIT=0
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
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

        stage('Deploy Docker Container') {
            steps {
                echo '🚀 Deploying new Docker container...'
                sh '''
                    echo "Stopping old container (if any)..."
                    docker ps -q --filter "name=${CONTAINER_NAME}" | grep -q . && docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME} || echo "No existing container."

                    echo "Running new container from ${IMAGE_NAME}:${IMAGE_TAG}..."
                    docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:8080 ${IMAGE_NAME}:${IMAGE_TAG}

                    echo "✅ New container deployed successfully!"
                    docker ps --filter "name=${CONTAINER_NAME}"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed — check the console logs for details.'
        }
    }
}
