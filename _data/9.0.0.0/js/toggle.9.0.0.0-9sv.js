
function toggle(sectionName,displayType){if(document.getElementById(sectionName).style.display=='none')
expand(sectionName,displayType);else
collapse(sectionName);}
function expand(sectionName,displayType){document.getElementById(sectionName).style.display=displayType;var sw=document.getElementById(sectionName+'_switch');if(sw)sw.src='/images/minus.gif';}
function collapse(sectionName){document.getElementById(sectionName).style.display='none';var sw=document.getElementById(sectionName+'_switch');if(sw)sw.src='/images/plus.gif';}