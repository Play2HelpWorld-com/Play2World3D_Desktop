pipeline {
    agent any // Use any available agent

    environment {
        GCS_BUCKET = 'indexpck' // Replace with your GCS bucket name
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git repository
                dir('/home/godot/Play2World3D_Desktop') { // Change to the desired checkout directory
                    git branch: 'development', url: 'https://github.com/Play2HelpWorld-com/Play2World3D_Desktop.git' // Replace with your git repo URL
                }
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

                    // Run Godot export command to create a ZIP file
                    dir('/home/godot/zip_folder') { // Ensure the correct directory for export
                        sh "godot --headless --export-pack 'win' ${zipFileName}"
                    }

                    // Upload the ZIP file to GCS
                    sh "gsutil cp /home/godot/${zipFileName} gs://$GCS_BUCKET/"
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
