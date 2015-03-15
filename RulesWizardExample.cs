using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace Template
{
    // Define a simple class that represents a mail message
    public class MailMessage
    {
        public MailMessage(string to, string from, string body)
        {
            this.To = to;
            this.From = from;
            this.Body = body;
        }

        public String To;
        public String From;
        public String Body;
    }

    public class RulesWizardExample
    {
        public static void Main(string[] args)
        {
            // Ensure that they've provided some script text
            if(args.Length == 0)
            {
                Console.WriteLine("Usage:");
                Console.WriteLine(" RulesWizardExample <script text>");
                return;                                    
            }

            // Create an example message to pass to our rules wizard
            MailMessage mailMessage = 
                        new MailMessage(
                            "guide_feedback@leeholmes.com",
                            "guide_reader@example.com",
                            "This is a message about your book.");

            // Create a runspace, which is the environment for
            // running commands
            Runspace runspace = RunspaceFactory.CreateRunspace(); 
            runspace.Open(); 

            // Create a variable, called "$message" in the Runspace, and populate
            // it with a reference to the current message in our application.
            // Pipeline commands can interact with this object like any other 
            // .Net object. 
            runspace.SessionStateProxy.SetVariable("message", mailMessage); 

            // Create a pipeline, and populate it with the script given in the 
            // first command line argument. 
            Pipeline pipeline = runspace.CreatePipeline(args[0]); 

            // Invoke (execute) the pipeline, and close the runspace. 
            pipeline.Invoke(); 
            runspace.Close(); 
        }
    }
}