

pipeline {


	agent none
	environment{
		COMPLIANCEENABLED = true
	}

	options{
		skipDefaultCheckout()
		buildDiscarder(logrotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '5', numToKeepStr: '10'))
	}

	stages{

		stage('Build'){

			agent{
				docker{
					image 'maven:3.5'
					label 'dind'
					args '-v /root/.m2:/root/.m2'
				}
			}


			steps{

				checkout scm
				script{
					env.gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
		        echo "Commit ID : ${gitCommit}"
		        }
		        
		        sh 'mvn -DskipTests clean install'
		        stash includes: 'target/*.jar', name: 'artifact'
		        }
				post {
					always{
						deleteDir()
					}
					success{
						echo " Build stage completed"
					}
					failure{
						echo " Build stage failed"
					}
					
					}
				}
}
}