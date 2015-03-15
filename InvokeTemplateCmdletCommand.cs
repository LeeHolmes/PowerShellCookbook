using System;
using System.ComponentModel;
using System.Management.Automation;

/*
To build and install:

1) Set-Alias csc $env:WINDIR\Microsoft.NET\Framework\v2.0.50727\csc.exe
2) $ref = [PsObject].Assembly.Location
3) csc /out:TemplateBinaryModule.dll /t:library InvokeTemplateCmdletCommand.cs /r:$ref
4) Import-Module .\TemplateBinaryModule.dll

To run:

PS >Invoke-TemplateCmdlet
*/

namespace Template.Commands
{
    [Cmdlet("Invoke", "TemplateCmdlet")]
    public class InvokeTemplateCmdletCommand : Cmdlet
    {
        [Parameter(Mandatory=true, Position=0, ValueFromPipeline=true)]
        public string Text
        {
            get
            {
                return text;
            }
            set
            {
                text = value;
            }
        }
        private string text;

        protected override void BeginProcessing()
        {
            WriteObject("Processing Started");
        }

        protected override void ProcessRecord()
        {
            WriteObject("Processing " + text);
        }

        protected override void EndProcessing()
        {
            WriteObject("Processing Complete.");
        }
    }
}