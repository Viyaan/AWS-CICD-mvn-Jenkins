

pipeline {


	agent none
	environment{
		COMPLIANCEENABLED = true
	}

	options{
		skipDefaultCheckout()
		buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '5', numToKeepStr: '10'))
	}

	stages{

		stage('Build'){
			
			

			//agent{
				//	docker{
				//	image 'maven:3.5'
				//label 'dind'
				//args '-v /root/.m2:/root/.m2'
				//}
			//}


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

		stage('Unit Test'){

			steps{
				checkout scm
				sh 'mvn -Dmaven.test.failure.ignore.test'
			}
			post {
				always{
					deleteDir()
				}
				success{
					script{

						echo 'STARTING SUREFIRE TEST'
						sh 'mvn surefire-report:report-only'
					}

					echo " Unit Test stage completed"
					deleteDir()
				}
				failure{
					echo " Unit Test stage failed"
					deleteDir()
				}
			}
		}


		stage('Documentation'){

			steps{
				checkout scm
				sh 'mvn -e javadoc:javadoc'
			}
			post {
				always{
					deleteDir()
				}
				success{
					script{

						step([$class: 'JavadocArchiver', javadocDir:'target/site/apidocs', keepAll:false])
					}

					echo " Documentation stage completed"
					deleteDir()
				}
				failure{
					echo " Documentation stage failed"
					deleteDir()
				}
			}
		}
	}
}

