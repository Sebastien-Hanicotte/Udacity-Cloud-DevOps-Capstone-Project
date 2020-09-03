pipeline {
    agent any
    tools {
        nodejs "node"
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                   '''
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
    }
}
