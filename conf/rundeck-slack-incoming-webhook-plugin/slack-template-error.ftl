<#if executionData.job.group??>
    <#assign jobName="${executionData.job.group} / ${executionData.job.name}">
<#else>
    <#assign jobName="${executionData.job.name}">
</#if>
<#assign message="FAILED! Job <${executionData.href}|#${executionData.id}  ${jobName}>">
<#assign state="Failed">

<#if executionData.argstring??>
    <#assign args="${executionData.argstring}">
<#else>
    <#assign args="No options to display">
</#if>


<#if executionData.succeededNodeListString??>
    <#assign successNodes="${executionData.succeededNodeListString}">
<#else>
    <#assign successNodes="None">
</#if>

<#if executionData.context.option.slackUserId??>
    <#assign slackUserId="${executionData.context.option.slackUserId}">
<#else>
    <#assign slackUserId="">
</#if>

{
   "attachments":[
      {
         "fallback":"${state}: ${message}",
         "pretext":"${message}",
         "color":"${color}",
         "text":"${slackUserId}",
         "fields":[
            {
               "title":"Job Name",
               "value":"<${executionData.job.href}|${jobName}>",
               "short":false
            },
            {
                "title": "Job Start Time",
                "value": "${executionData.dateStarted}",
                "short": true
            },
            {
                "title": "Job End Time",
                "value": "${executionData.dateEnded}",
                "short": true
            },
            {   "title": "Project",
                "value": "${executionData.project}",
                "short": true
            },
            {
               "title":"Started By",
               "value":"${executionData.user}",
               "short":true
            },
            {
               "title":"Failed On",
               "value":"${executionData.failedNodeListString}",
               "short":false
            },
            {
                "title": "Successful On",
                "value": "${successNodes}",
                "short": false
            }
        ]
      }
   ]
}