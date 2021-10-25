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
     environment{
          TF_VAR_VAULT_URL=""
        }

    stages {
        
        stage('Get files') {
            agent { label 'terraform:1.0' }
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
                label 'terraform:1.0'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault/infrastructure"){
                      withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                         sh "terragrun run-all plan --terragrunt-non-interactive"
                        }
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
                label 'terraform:1.0'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
                container('terraform') {
                   dir("vault/infrastructure"){
                       script{
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            sh "terragrun run-all apply --terragrunt-non-interactive"
                            def ip = sh(script: 'terraform run-all output leader', returnStdout: true)
                            echo "${ip}"
                            env.TF_VAR_VAULT_URL = "${ip}"
                            echo "${env.TF_VAR_VAULT_URL}"
                            }
                        }
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
                label 'terraform:1.0'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault/configuration"){
                           script{
                        withCredentials([sshUserPrivateKey(credentialsId: 'qd-demo-pem',keyFileVariable: 'SSH_KEY')])
                        {
                            sh 'cp "$SSH_KEY" files/qd-key.pem'
                            sh 'terraform plan -out tfplan'
                            echo 'ssh -l ubuntu ${env.TF_VAR_VAULT_URL} -i files/qd-key.pem "cat ~/root_token"'
                            env.TF_VAR_VAULT_TOKEN = sh(script: 'ssh -l ubuntu ${env.TF_VAR_VAULT_URL} -i qd-key.pem "cat ~/root_token"', returnStdout: true)
                            sh "terragrun run-all plan --terragrunt-non-interactive"
                            }
                        }
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
                label 'terraform:1.0'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
              container('terraform') {
                    dir("vault/configuration"){
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
