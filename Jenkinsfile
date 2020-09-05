pipeline {
    environment {
        dockerhubCredentials = 'dockerhubCredentials'
    }
    agent any
    tools {
        nodejs "node"
    }
    stages {
        stage('Hashing images') {
            steps {
                script {
                    env.GIT_HASH = sh(
                        script: "git show --oneline | head -1 | cut -d' ' -f1",
                        returnStdout: true
                    ).trim()
                }
            }
        }
        stage('Lint Dockerfile') {
            steps {
                script {
                    docker.image('hadolint/hadolint:latest-debian').inside() {
                        sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
                        sh '''
                            lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
                            if [ "$lintErrors" -gt "0" ]; then
                                echo "Errors have been found, please see below"
                                cat hadolint_lint.txt
                                exit 1
                            else
                                echo "There are no erros found on Dockerfile!!"
                            fi
                        '''
                    }
                }
            }
        }
        stage('Install NodeJS') {
            steps {
                sh 'npm install --prefix app'
            }
        }
        stage('Lint NodeJS') {
            steps {
                sh 'npm run lint --prefix app'
            }
        }
        stage('Test NodeJS') {
            steps {
                sh 'CI=true npm test --prefix app'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build --prefix app'
            }
        }
        stage('Build & Push to dockerhub') {
            steps {
                script {
                    dockerImage = docker.build("chtiseb/capstone-project:${env.GIT_HASH}")
                    docker.withRegistry('', dockerhubCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Scan Dockerfile to find vulnerabilities') {
            steps{
                aquaMicroscanner imageName: "chtiseb/capstone-project:${env.GIT_HASH}", notCompliesCmd: 'exit 4', onDisallowed: 'fail', outputFormat: 'html'
            }
        }
        stage('Build Docker Container') {
      		steps {
			    sh 'docker run --name capstone -d -p 80:80 chtiseb/capstone-project:${env.GIT_HASH}'
            }
        }
        stage("Cleaning Docker up") {
            steps {
                script {
                    sh "echo 'Cleaning Docker up'"
                    sh "docker system prune"
                }
            }
        } 
    }
}
