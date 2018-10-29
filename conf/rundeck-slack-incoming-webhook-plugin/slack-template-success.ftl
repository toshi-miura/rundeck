<#if executionData.job.group??>
    <#assign jobName="${executionData.job.group} / ${executionData.job.name}">
<#else>
    <#assign jobName="${executionData.job.name}">
</#if>
<#assign message="SUCCESS Job <${executionData.href}|#${executionData.id}  ${jobName}>">

<#if executionData.argstring??>
    <#assign args="${executionData.argstring}">
<#else>
    <#assign args="No arguments to display">
</#if>

<#assign state="Succeeded">

{
   "attachments":[
      {
         "fallback":"${state}: ${message}",
         "pretext":"${message}",
         "color":"${color}",
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
            {
               "title":"Started By",
               "value":"${executionData.user}",
               "short":true
            },
            {
               "title":"Project",
               "value":"${executionData.project}",
               "short":true
            }
	     ]
      }
   ]
}
