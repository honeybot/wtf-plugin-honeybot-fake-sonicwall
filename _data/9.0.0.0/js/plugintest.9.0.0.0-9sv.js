
function toUpdate(type,verstring)
{var toUpdate=0;var installedVersion;var plugins=window.navigator.plugins;var n=0;var plugin_name='';while(plugins.item(n)!=null)
{if(type=='VA')
{plugin_name=plugins.item(n).name.substring(0,23);if(plugin_name=="Virtual Assist Launcher")
{installedVersion=plugins.item(n).name.substring(24);break;}}
else
{plugin_name=plugins.item(n).name.substring(0,24);if(plugin_name=="Virtual Meeting Launcher")
{installedVersion=plugins.item(n).name.substring(25);break;}}
n++;}
if(null==installedVersion)
{return 1;}
var parts1=installedVersion.split(/\./);var parts2=verstring.split(/\./);for(var i=0;i<parts1.length;i++)
{if(parts2.length<=i||parseInt(parts2[i])<parseInt(parts1[i]))
break;if(parseInt(parts2[i])>parseInt(parts1[i]))
{toUpdate=1;break;}}
var agent=navigator.userAgent.toLowerCase();if(agent.indexOf("chrome")==-1&&type=='VM'&&toUpdate==1)
{if(parseInt(parts1[0])<=6&&parseInt(parts1[3])<=3)
{toUpdate=-1;}}
return toUpdate;}
function pluginLoadFunc(type,verstring)
{var agent=navigator.userAgent.toLowerCase();var toupdate=0;if(/windows/.test(agent))
{if(agent.indexOf("msie")!=-1)
{return true;}
else if(agent.indexOf('gecko')!=-1)
{toupdate=toUpdate(type,verstring);if(toupdate==1)
{if(agent.indexOf("chrome")==-1)
{if(type=='VA')
xpi={'VALauncher':'/VALauncher.xpi'};else
xpi={'VMLauncher':'/VMLauncher.xpi'};InstallTrigger.install(xpi);}
else
{return false;}}
else if(toupdate==-1)
{alert("Current Virtual Meeting Launcher is not up to date, please uninstall it before installing the latest one.");}}
else
return true;}
else
return true;return true;}