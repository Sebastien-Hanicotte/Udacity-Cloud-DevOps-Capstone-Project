pipeline {
    agent any
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
        stage('Lint') {
            parallel {
                stage('Lint HTML') {
                    steps {
                        #sh 'tidy -q -e *.html'
                        script { 
                           docker.image('imega/base-builder:1.2.0').inside() {
                               sh 'tidy -q -e *.html' | tee -a imega_tidy.txt'
                               sh '''
                                   tidyErrors=$(stat --printf="%s" imega_tidy.txt)
                                   if [ "$tidtErrors" -gt "0" ]; then
                                       echo "Errors have been found, please see below"
                                       cat imega_tidy.txt
                                       exit 1
                                   else
                                       echo "There are no erros found on index.html!!"
                                   fi
                               '''
                           }
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
            }
        }
    }
}
