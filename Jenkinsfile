pipeline {
    agent none
    //see https://www.jenkins.io/doc/book/pipeline/syntax/#options    
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout()
        skipStagesAfterUnstable()
    }

    stages {
        
        stage('Get files') {
            agent { label 'terraform:1.0.13' }
            steps {
                container('terraform') {
                    checkout scm

                    stash includes: '**', name: 'terraform-files'
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Plan dev') {
            agent {
                label 'terraform:1.0.13'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault-infrastructure"){
                         sh "terragrun run-all plan --terragrunt-non-interactive"
                    }
                }
            }
            post {
                failure{
                        echo "========Pipeline execution failed========"
                    }
                }
        }

        stage('Apply on DEV') {
            agent {
                label 'terraform:1.0.13'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault-infrastructure"){
                        sh "terragrun run-all apply --terragrunt-non-interactive"
                    }
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Plan Vault config on DEV') {
            agent {
                label 'terraform:1.0.13'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault-configuration"){
                        sh "terragrun run-all plan --terragrunt-non-interactive"
                    }
                }
            }
            post {
            failure{
                    echo "========Pipeline execution failed========"
                }
            }
        }

        stage('Apply Vault configuration on DEV') {
            agent {
                label 'terraform:1.0.13'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
              container('terraform') {
                    dir("vault-configuration"){
                        sh "terragrun run-all apply --terragrunt-non-interactive"
                    }
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }
    }
    // common
    post {
        always{
            echo "========always========"
        }
        success{
            echo "========Pipeline executed successfully========"
        }
        failure{
            echo "========Pipeline execution failed========"
        }
    }
}