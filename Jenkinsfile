def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline{
    agent any
    options{
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    stages{
        stage('Git Checkout Ansible'){
            steps{
                deleteDir()  // clean up our workspace
                sh 'mkdir -p ansible'
                dir("ansible")
                {
                    git branch: 'ansible',
                    credentialsId: 'jenkins-ssh-to-git',
                    url: 'git@github.com:CodePathfinder/cicd_project.git'
                }
            }
        }
        stage('Git Checkout Website'){
            steps{
                sh 'mkdir -p my_website'
                dir("my_website")
                {
                    git branch: 'main',
                    credentialsId: 'jenkins-ssh-to-git',
                    url: 'git@github.com:CodePathfinder/antique_cafe.git'
                }
            }
        }
        stage('Copy Inventory File'){
            steps{
                sh 'aws s3 ls s3://terraform-state-cicd/hosts/'
                sh 'aws s3 cp s3://terraform-state-cicd/hosts/ ./ansible/ --recursive'
                sh 'cat ./ansible/*.txt > ./ansible/hosts.txt'
                sh 'cat ./ansible/hosts.txt'
			}
        }
        stage('Lookup on workspace tree'){
            steps{
                echo "WORKSPACE: ${WORKSPACE}"
                sh 'tree ${WORKSPACE}'
			}
        }
        stage('Execute Ansible: Deploy'){
            steps{
                ansiblePlaybook(
				    playbook: 'ansible/deploy_to_web_apache.yml',
				    inventory: 'ansible/hosts.txt',
				    disableHostKeyChecking: true
				)
			}
        }
    }
    post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#someproject',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job '${env.JOB_NAME}' build #${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}console"
        }
    }
}
