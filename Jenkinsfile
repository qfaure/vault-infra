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
                    dir("vault/config/infrastructure"){
                      withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                         sh "terragrunt run-all plan --terragrunt-non-interactive -lock=false"
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
                   dir("vault/config/infrastructure"){
                       script{
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            sh "terragrunt run-all apply --terragrunt-non-interactive -lock=false"
                            def ip = sh(script: 'terragrunt run-all output -raw leader', returnStdout: true)
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

        stage('Manual Approval for deploying vault') {
            agent none
            steps {
                    input message:'Approve deploying vault config?', ok:'Yes, Deploy'
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
                    dir("vault/config/configuration"){
                       script {
                            sshagent(['qd-demo-ec2-pem']) {
                                 echo "${env.TF_VAR_VAULT_URL}"
                                def command = "ssh -o StrictHostKeyChecking=no -l ubuntu ${env.TF_VAR_VAULT_URL} \"cat ~/root_token\""
                                echo "${command}"
                                env.TF_VAR_VAULT_TOKEN = sh(script: "${command}", returnStdout: true).trim()
                                echo "${env.TF_VAR_VAULT_TOKEN}"
                                withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "qf-aws",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) 
                                {
                                    sh "terragrunt run-all plan --terragrunt-non-interactive -var=vault_token=${env.TF_VAR_VAULT_TOKEN}"
                                }
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
                    dir("vault/config/configuration"){
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',credentialsId: "qf-aws",accessKeyVariable: 'AWS_ACCESS_KEY_ID',secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                            withCredentials([string(credentialsId: 'qf-vault-pwd', variable: 'QF_PASSWORD')]) {
                            sh "terragrunt run-all apply --terragrunt-non-interactive -var=vault_token=${env.TF_VAR_VAULT_TOKEN} -var=qf-vault-pwd=${QF_PASSWORD}"
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
