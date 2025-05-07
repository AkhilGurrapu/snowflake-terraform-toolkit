#!/usr/bin/env groovy

library(
        identifier: 'analytics-platform-snowflake-base@193602_automate_edpnonprod_stored_procedure_deployments',
        retriever: modernSCM(
                [$class: 'GitSCMSource',
                 remote: 'git@github.com:rgare/analytics-platform-jenkins.git',
                 credentialsId: 'jenkins-autokeygen-analytics-platform-jenkins']
        )
)

FlywaySnowflakePipeline {
  snowflake_team_account = 'edp_nonprod'
  envOverride = 'nonprod'
  migrationDir = 'admin_db/admin_sch'

}