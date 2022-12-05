pipeline{
    agent any
    options{
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    stages{
        stage('Git Checkout Project'){
            steps{
                deleteDir()  // clean up our workspace
                {
                    git branch: 'main',
                    credentialsId: 'ssh-key-github',
                    url: 'git@github.com:CodePathfinder/cicd_project.git'
                }
            }
        }
        stage('Lookup on workspace tree'){
            steps{
                echo "WORKSPACE: ${WORKSPACE}"
                sh 'tree ${WORKSPACE}'
			}
        }
    }
}
