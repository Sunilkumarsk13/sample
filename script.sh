#!/bin/bash

file="/home/redhat.secure/script.properties"

function prop {
    grep "${1}" ${file} | cut -d'=' -f2
}

#Append date stamp to file
file_name=graph.db-backup
current_time=$(date "+%Y%m%d-%H%M%S")
new_fileName=$current_time.$file_name

#taking the backup of Neo4j
echo "*************Database Backup Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Database Backup Started**************"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup started."
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "docker exec $(prop 'D_neo4jDockerContainerName') sh -c 'mkdir $(prop 'D_neo4jContainerBackupFolder');neo4j-admin backup --from=localhost --backup-dir=$(prop 'D_neo4jContainerBackupFolder') --name='$(prop 'S_nFlowsReleaseVersion')_$new_fileName' --pagecache=4G'"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') mkdir $(prop 'D_neo4jBackupFolder')
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') docker cp $(prop 'D_neo4jDockerContainerName'):$(prop 'D_neo4jContainerBackupFolder')/$(prop 'S_nFlowsReleaseVersion')_$new_fileName $(prop 'D_neo4jBackupFolder')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup completed."
echo "************Database Backup Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Database Backup Completed*************"

echo ""

#taking the application backup 
echo "************Application Backup Started************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Application Backup Started************"
#creating the directory and copying the backup data.
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup started."
mkdir -p $(prop 'applicationBackupFolder')/$current_time 
docker cp $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')/$(prop 'applicationname') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup completed."

#taking the Dataload service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup started."
docker cp $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')/$(prop 'dataLoadEngineName') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup completed."

#taking the RuleEngine Service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup started."
docker cp $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')/$(prop 'ruleEngineName') $(prop 'applicationBackupFolder')/$current_time/ 
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup completed."

#taking the nFlowsExportAPI Service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup started."
docker cp $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')/$(prop 'exportAPIName') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup completed."
echo "**********Application Backup Completed************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Backup Completed************"

echo ""

#taking the Configfiles backup
echo "************Config File Backup Started************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Config File Backup Started************"
#creating the directory and copying the backup data.
mkdir $(prop 'configurationFileFolder')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'applicationConfigfileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'applicationConfigFilePath')/$(prop 'applicationConfigFileName') $(prop 'configurationFileFolder')/$(prop 'applicationConfigfileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup completed."

#taking the Dataload service config backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
mkdir $(prop 'configurationFileFolder')/$(prop 'dataloadConfigFileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'dataloadConfigFilePath')/$(prop 'dataloadConfigFileName') $(prop 'configurationFileFolder')/$(prop 'dataloadConfigFileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log

#taking the RuleEngine Service configfile backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'ruleEngineConfigFileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'ruleEngineConfigFilepath')/$(prop 'ruleengineConfigFileName') $(prop 'configurationFileFolder')/$(prop 'ruleEngineConfigFileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup completed."

#taking the ExportAPI Service configfile backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'exportAPIconfigfileBackup') 
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'exportAPIConfigFilepath')/$(prop 'exportAPIConfigFileName') $(prop 'configurationFileFolder')/$(prop 'exportAPIconfigfileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup completed."
echo "*********Config File Backup Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*********Config File Backup Completed*************"

echo ""

#Neo4j Plugin Replacing in Container

echo "*************Neo4j Plugin Replacing Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Neo4j Plugin Replacing Started**************"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "Pluginfile='ls $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jPluginPath') |wc-l'"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "if [ $Pluginfile > 0 ]; then 'docker cp $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jPluginPath') $(prop 'D_neo4jDockerContainerName'):$(prop 'D_neo4jContainerPluginPath')' else echo 'file not found in Release Folder' >> nFlowsReleaselog_before_$(prop 'nFlowsReleaseVersion')_$current_time.log;fi"
echo "*************Neo4j Plugin Replacing Completed**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Neo4j Plugin Replacing Completed**************"

#Neo4j Scripts update
echo "*************Release Process Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Release Process Started**************"
echo ""
echo "*******Database Release Scripts Started***********" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*******Database Release Scripts Started***********"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution started."
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "sed -i -e 's/<NFLOWS_NEO4J_DB_CONTAINER_NAME>/$(prop 'D_neo4jDockerContainerName')/g' $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jScriptPath')/$(prop 'D_neo4jscriptfile')"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "sed -i -e 's/<NEO4J_DB_USER_NAME>/$(prop 'D_neo4jContainerUsername')/g' $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jScriptPath')/$(prop 'D_neo4jscriptfile')"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "sed -i -e 's/<NEO4J_DB_PASSWORD>/$(prop 'D_neo4jContainerPassword')/g' $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jScriptPath')/$(prop 'D_neo4jscriptfile')"

sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "cd $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jScriptPath');bash $(prop 'D_releaseFolderPath')$(prop 'D_nFlowsReleaseVersion')/$(prop 'D_neo4jScriptPath')/$(prop 'D_neo4jscriptfile')"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution completed."
echo "*******Database Release Scripts Completed*********" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*******Database Release Scripts Completed*********"

echo ""



#WAR File replacement in the container
echo "**********Application Release Started*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Release Started*************"

#Application Container WAR File Replacement
ApplicationWarFile=`ls  $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'applicationRelease') | wc -l`
if [ $ApplicationWarFile -gt 0 ] 
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'applicationRelease') $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment completed."
else
echo $current_time "Application WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "Application WAR file is not available"
fi


#Dataload Engine Container WAR File Replacement
DataloadWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'dataloadRelease') | wc -l`
if [ $DataloadWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'dataloadRelease') $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started."
else
echo $current_time "Dataload WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "Dataload WAR file is not available"
fi


#Rule Engine Container WAR File Replacement
RuleEngineWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'ruleEngineRelease') | wc -l`
if [ $RuleEngineWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'ruleEngineRelease') $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement completed."
else
echo $current_time "RuleEngine WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "RuleEngine WAR file is not available"
fi


#ExportAPI Container WAR File Replacement
ExportAPIWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'exportAPIRelease') | wc -l`
if [ $ExportAPIWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'exportAPIRelease') $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement completed."
else
echo $current_time "ExportAPI WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "ExportAPI WAR file is not available"
fi

echo "**********Application Release completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Release completed*************"

echo ""


#update the config file from previous backup version
echo "**********Update Config File Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Update Config File Started**************"
#Application container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'applicationConfigFilePath')/$(prop 'applicationConfigFileName') $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')/$(prop 'applicationname')/$(prop 'WEBINFclassespath')/$(prop 'applicationConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update completed."

#Dataload container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update Started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update Started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'dataloadConfigFilePath')/$(prop 'dataloadConfigFileName') $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')/$(prop 'dataLoadEngineName')/$(prop 'WEBINFclassespath')/$(prop 'dataloadConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update completed."

#RuleEngine container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'ruleEngineConfigFilepath')/$(prop 'ruleengineConfigFileName') $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')/$(prop 'ruleEngineName')/$(prop 'WEBINFclassespath')/$(prop 'ruleengineConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "-RuleEngine container update completed" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "-RuleEngine container update completed"

#ExportAPI container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'exportAPIConfigFilepath')/$(prop 'exportAPIConfigFileName') $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')/$(prop 'exportAPIName')$(prop 'WEBINFclassespath')/$(prop 'exportAPIConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update completed."
echo "**********Update Config File Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Update Config File Completed*************"

echo ""

# Restarting all Docker containers.
echo "**********Docker Containers Restart Started*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Docker Containers Restart Started*************"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart started."
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "docker container restart $(prop 'D_neo4jDockerContainerName')"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart started."
docker container restart $(prop 'applicationDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart started."
docker container restart $(prop 'dataloadDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart started."
docker container restart $(prop 'ruleEngineDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart started."
docker container restart $(prop 'exportAPIDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart completed."
echo "**********Docker Containers Restart Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Docker Containers Restart Completed*************"

echo ""

#Checking the status of containers
#1=UP 0=Exited
 
echo "**********checking the status of containers***************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********checking the status of containers***************"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Neo4j Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Neo4j Container"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "docker ps | grep $(prop 'D_neo4jDockerContainerName') | grep "Up" | wc -l"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Application Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Application Container"
docker ps | grep $(prop 'applicationDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Dataload Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Dataload Container"
docker ps | grep $(prop 'dataloadDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of RuleEngine Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of RuleEngine Container"
docker ps | grep $(prop 'ruleEngineDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of ExportAPI Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of ExportAPI Container"
docker ps | grep $(prop 'exportAPIDockerContainerName') | grep "Up" | wc -l













#######################SAME SERVER######################################


#!/bin/bash

file="/home/redhat.secure/script.properties"

function prop {
    grep "${1}" ${file} | cut -d'=' -f2
}

#Append date stamp to file
file_name=graph.db-backup
current_time=$(date "+%Y%m%d-%H%M%S")
new_fileName=$current_time.$file_name

#taking the backup of Neo4j
echo "*************Database Backup Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Database Backup Started**************"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup started."
docker exec $(prop 'S_neo4jDockerContainerName') sh -c 'mkdir $(prop 'S_neo4jContainerBackupFolder');neo4j-admin backup --from=localhost --backup-dir=$(prop 'S_neo4jContainerBackupFolder') --name='$new_fileName' --pagecache=4G'
mkdir $(prop 'S_neo4jBackupFolder')
docker cp $(prop 'S_neo4jDockerContainerName'):$(prop 'S_neo4jContainerBackupFolder')/$new_fileName $(prop 'S_neo4jBackupFolder')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j backup completed."
echo "************Database Backup Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Database Backup Completed*************"

echo ""

#taking the application backup 
echo "************Application Backup Started************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Application Backup Started************"
#creating the directory and copying the backup data.
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup started."
mkdir -p $(prop 'applicationBackupFolder')/$current_time 
docker cp $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')/$(prop 'applicationname') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App backup completed."

#taking the Dataload service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup started."
docker cp $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')/$(prop 'dataLoadEngineName') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload service backup completed."

#taking the RuleEngine Service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup started."
docker cp $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')/$(prop 'ruleEngineName') $(prop 'applicationBackupFolder')/$current_time/ 
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine service backup completed."

#taking the nFlowsExportAPI Service backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup started."
docker cp $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')/$(prop 'exportAPIName') $(prop 'applicationBackupFolder')/$current_time/
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI service backup completed."
echo "**********Application Backup Completed************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Backup Completed************"

echo ""

#taking the Configfiles backup
echo "************Config File Backup Started************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "************Config File Backup Started************"
#creating the directory and copying the backup data.
mkdir $(prop 'configurationFileFolder')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'applicationConfigfileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'applicationConfigFilePath')/$(prop 'applicationConfigFileName') $(prop 'configurationFileFolder')/$(prop 'applicationConfigfileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows App Config File backup completed."

#taking the Dataload service config backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
mkdir $(prop 'configurationFileFolder')/$(prop 'dataloadConfigFileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'dataloadConfigFilePath')/$(prop 'dataloadConfigFileName') $(prop 'configurationFileFolder')/$(prop 'dataloadConfigFileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log

#taking the RuleEngine Service configfile backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'ruleEngineConfigFileBackup')
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'ruleEngineConfigFilepath')/$(prop 'ruleengineConfigFileName') $(prop 'configurationFileFolder')/$(prop 'ruleEngineConfigFileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine configfile backup completed."

#taking the ExportAPI Service configfile backup
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup started."
mkdir $(prop 'configurationFileFolder')/$(prop 'exportAPIconfigfileBackup') 
cp -r $(prop 'applicationBackupFolder')/$current_time/$(prop 'exportAPIConfigFilepath')/$(prop 'exportAPIConfigFileName') $(prop 'configurationFileFolder')/$(prop 'exportAPIconfigfileBackup')/
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI configfile backup completed."
echo "*********Config File Backup Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*********Config File Backup Completed*************"

echo ""

#Neo4j Plugin Replacing in Container

echo "*************Neo4j Plugin Replacing Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Neo4j Plugin Replacing Started**************"
Pluginfile='ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jPluginPath') |wc-l'
if [ $Pluginfile > 0 ] 
then
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jPluginPath') $(prop 'S_neo4jDockerContainerName'):$(prop 'S_neo4jContainerPluginPath')
else
echo 'file not found in Release Folder' >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
fi
echo "*************Neo4j Plugin Replacing Completed**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Neo4j Plugin Replacing Completed**************"

#Neo4j Scripts update
echo "*************Release Process Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*************Release Process Started**************"
echo ""
echo "*******Database Release Scripts Started***********" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*******Database Release Scripts Started***********"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution started."
sed -i -e 's/<NFLOWS_NEO4J_DB_CONTAINER_NAME>/$(prop 'S_neo4jDockerContainerName')/g' $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jScriptPath')/$(prop 'S_neo4jscriptfile')
sed -i -e 's/<NEO4J_DB_USER_NAME>/$(prop 'S_neo4jContainerUsername')/g' $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jScriptPath')/$(prop 'S_neo4jscriptfile')
sed -i -e 's/<NEO4J_DB_PASSWORD>/$(prop 'S_neo4jContainerPassword')/g' $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jScriptPath')/$(prop 'S_neo4jscriptfile')

cd $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jScriptPath')
bash $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'S_neo4jScriptPath')/$(prop 'S_neo4jscriptfile')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j script execution completed."
echo "*******Database Release Scripts Completed*********" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "*******Database Release Scripts Completed*********"

echo ""



#WAR File replacement in the container
echo "**********Application Release Started*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Release Started*************"

#Application Container WAR File Replacement
ApplicationWarFile=`ls  $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'applicationRelease') | wc -l`
if [ $ApplicationWarFile -gt 0 ] 
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'applicationRelease') $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Application WAR file deployment completed."
else
echo $current_time "Application WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "Application WAR file is not available"
fi


#Dataload Engine Container WAR File Replacement
DataloadWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'dataloadRelease') | wc -l`
if [ $DataloadWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'dataloadRelease') $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows Dataload WAR file replacement started."
else
echo $current_time "Dataload WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "Dataload WAR file is not available"
fi


#Rule Engine Container WAR File Replacement
RuleEngineWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'ruleEngineRelease') | wc -l`
if [ $RuleEngineWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'ruleEngineRelease') $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows RuleEngine WAR file replacement completed."
else
echo $current_time "RuleEngine WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "RuleEngine WAR file is not available"
fi


#ExportAPI Container WAR File Replacement
ExportAPIWarFile=`ls $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'exportAPIRelease') | wc -l`
if [ $ExportAPIWarFile -gt 0 ]
then
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement started."
docker cp $(prop 'S_releaseFolderPath')$(prop 'S_nFlowsReleaseVersion')/$(prop 'exportAPIRelease') $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- nFlows ExportAPI WAR file replacement completed."
else
echo $current_time "ExportAPI WAR file is not available" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $current_time "ExportAPI WAR file is not available"
fi

echo "**********Application Release completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Application Release completed*************"

echo ""


#update the config file from previous backup version
echo "**********Update Config File Started**************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Update Config File Started**************"
#Application container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'applicationConfigFilePath')/$(prop 'applicationConfigFileName') $(prop 'applicationDockerContainerName'):$(prop 'applicationContainerPath')/$(prop 'applicationname')/$(prop 'WEBINFclassespath')/$(prop 'applicationConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Container update completed."

#Dataload container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update Started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update Started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'dataloadConfigFilePath')/$(prop 'dataloadConfigFileName') $(prop 'dataloadDockerContainerName'):$(prop 'dataloadContainerPath')/$(prop 'dataLoadEngineName')/$(prop 'WEBINFclassespath')/$(prop 'dataloadConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload container update completed."

#RuleEngine container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'ruleEngineConfigFilepath')/$(prop 'ruleengineConfigFileName') $(prop 'ruleEngineDockerContainerName'):$(prop 'ruleEngineContainerPath')/$(prop 'ruleEngineName')/$(prop 'WEBINFclassespath')/$(prop 'ruleengineConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "-RuleEngine container update completed" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "-RuleEngine container update completed"

#ExportAPI container update from previous version
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update started."
docker cp $(prop 'applicationBackupFolder')/$current_time/$(prop 'exportAPIConfigFilepath')/$(prop 'exportAPIConfigFileName') $(prop 'exportAPIDockerContainerName'):$(prop 'exportAPIContainerPath')/$(prop 'exportAPIName')$(prop 'WEBINFclassespath')/$(prop 'exportAPIConfigFileName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI container update completed."
echo "**********Update Config File Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Update Config File Completed*************"

echo ""

# Restarting all Docker containers.
echo "**********Docker Containers Restart Started*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Docker Containers Restart Started*************"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart started."
docker container restart $(prop 'S_neo4jDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Neo4j Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart started."
docker container restart $(prop 'applicationDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Application Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart started."
docker container restart $(prop 'dataloadDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Dataload Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart started."
docker container restart $(prop 'ruleEngineDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- RuleEngine Docker Container Restart completed."

echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart started." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart started."
docker container restart $(prop 'exportAPIDockerContainerName')
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart completed." >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- ExportAPI Docker Container Restart completed."
echo "**********Docker Containers Restart Completed*************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********Docker Containers Restart Completed*************"

echo ""

#Checking the status of containers
#1=UP 0=Exited
 
echo "**********checking the status of containers***************" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo "**********checking the status of containers***************"
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Neo4j Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Neo4j Container"
sshpass -p $(prop 'D_serverpassword') ssh $(prop 'D_UserName')@$(prop 'D_IPAddress') "docker ps | grep $(prop 'D_neo4jDockerContainerName') | grep "Up" | wc -l"

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Application Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Application Container"
docker ps | grep $(prop 'applicationDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Dataload Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of Dataload Container"
docker ps | grep $(prop 'dataloadDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of RuleEngine Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of RuleEngine Container"
docker ps | grep $(prop 'ruleEngineDockerContainerName') | grep "Up" | wc -l

echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of ExportAPI Container" >> nFlowsReleaselog_before_$(prop 'S_nFlowsReleaseVersion')_$current_time.log
echo $(date "+%Y-%m-%d %H:%M:%S") "- Checking the status of ExportAPI Container"
docker ps | grep $(prop 'exportAPIDockerContainerName') | grep "Up" | wc -l

