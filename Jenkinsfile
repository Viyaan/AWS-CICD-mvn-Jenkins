pipeline {
	agent{
		label 'master'
	}
	tools {
		maven 'maven'
	}
	environment{ COMPLIANCEENABLED = true }
	options{
		skipDefaultCheckout()
		buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '5', numToKeepStr: '10'))
	}
	stages{
		stage('Build'){
			steps{
				checkout scm
				sh 'mvn -DskipTests clean install'
				stash includes: 'target/*.jar', name: 'artifact'
			}
			post {
				success{ echo " Build stage completed" }
				failure{ echo " Build stage failed" }
				always{
					deleteDir()
				}
			}
		}

		stage('Unit Test'){

			steps{
				checkout scm
				sh 'mvn test'
			}
			post {
				success{
					script{

						echo 'STARTING SUREFIRE TEST'
						sh 'mvn surefire-report:report-only'
						echo 'STARTING JACOCO TEST'
						sh 'mvn jacoco:prepare-agent install jacoco:report'
						echo 'Junit SUREFIRE TEST'
						junit 'target/surefire-reports/*.xml'
						step([$class:'JacocoPublisher'])
					}

					publishHTML (target: [
						allowMissing: false,
						alwaysLinkToLastBuild: false,
						keepAll: true,
						reportDir: 'target/jacoco-ut',
						reportFiles: 'index.html',
						reportName: "Coverage HTML Report"
					])

					echo " Unit Test stage completed"
				}
				failure{
					echo " Unit Test stage failed"
				}
				cleanup{
					deleteDir()
				}
			}
		}


		stage('SonarQube analysis') {
			steps {
				withSonarQubeEnv('SonarQube') {
					withMaven(maven:'maven') {
						sh 'mvn clean package sonar:sonar'
					}
				}
			}
		}

		stage("Quality Gate") {
			steps {
				timeout(time: 1, unit: 'HOURS') {
					// Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
					// true = set pipeline to UNSTABLE, false = don't
					waitForQualityGate abortPipeline: true
				}
			}
		}


		stage("CxSAST Scan") {
			steps {
				step([$class: 'CxScanBuilder',
					 comment: '',
					 credentialsId: '',
					 excludeFolders: '',
					 excludeOpenSourceFolders: '',
					 exclusionsSetting: 'global',
					 failBuildOnNewResults: true,
					 failBuildOnNewSeverity: 'HIGH',
					 filterPattern: '',
					 fullScanCycle: 10,
					 generatePdfReport: true,
					 includeOpenSourceFolders: '',
					 osaArchiveIncludePatterns: '*.zip, *.war, *.ear, *.tgz',
					 osaInstallBeforeScan: false,
					 password: '{AQAAABAAAAAQrdI0oA8y13zZc0dnrxgozGpjQrXFfJM4jrsyF5EaI3w=}',
					 projectName: 'test',
					 sastEnabled: true,
					 serverUrl: '',
					 sourceEncoding: '1',
					 username: '',
					 vulnerabilityThresholdResult: 'FAILURE',
					 waitForResultsEnabled: true])
			}
			post{
				success{echo 'SAST check Completed'}
				failure{echo 'SAST check Failed'}
			}
		}



		stage('Documentation'){

			steps{
				checkout scm
				sh 'mvn -e javadoc:javadoc'
			}
			post {
				success{
					script{
						step([$class: 'JavadocArchiver', javadocDir:'target/javadoc/apidocs', keepAll:false])
					}
					echo " Documentation stage completed"
				}
				failure{
					echo " Documentation stage failed"
				}
				cleanup{
					deleteDir()
				}
			}
		}



		stage('Docker'){

			environment { DOCKER_CREDS =credentials('docker')}
			steps{
				checkout scm
				unstash name: 'artifact'
				sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW'
				sh 'docker build -t viyaandocker/sample-spring-boot:latest .'
				sh 'docker push viyaandocker/sample-spring-boot:latest'
			}
			post {
				success{

					echo " Docker stage completed"
				}
				failure{
					echo " Docker stage failed"
				}
				cleanup{
					deleteDir()
				}
			}
		}
	}

	post{

		success{
			echo ' Pipeline successfull'
		}
		failure{
			echo ' Pipeline Failed'
		}
	}
}

