pipeline {
    agent any // Use any available agent

    environment {
        GCS_BUCKET = 'indexpck' // Replace with your GCS bucket name
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git repository
                git branch: 'development', url: 'https://github.com/Play2HelpWorld-com/Play2World3D_Desktop.git' // Replace with your git repo URL
            }
        }

        stage('Get Git Build Number') {
            steps {
                script {
                    // Get the latest commit hash and set it as a variable
                    env.GIT_BUILD_NUMBER = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                }
            }
        }

        stage('Export to ZIP') {
            steps {
                script {
                    // Define the output ZIP file name using the build number
                    def zipFileName = "play2world3d_desktop_${env.GIT_BUILD_NUMBER}.zip"

                    // Path for zip folder
                    def zipFolderPath = '/home/godot/zip_folder'

                    // Ensure the zip_folder exists before exporting
                    sh "mkdir -p ${zipFolderPath}"

                    // Run Godot export command to create a ZIP file
                    sh "godot --headless --export-pack 'win' ${zipFolderPath}/${zipFileName}"

                    // Upload the ZIP file to GCS
                    sh "gsutil cp ${zipFolderPath}/${zipFileName} gs://$GCS_BUCKET/"
                }
            }
        }
    }

    post {
        success {
            echo 'Export to ZIP and upload to GCS completed successfully!'
        }
        failure {
            echo 'There was an error in the pipeline.'
        }
    }
}
