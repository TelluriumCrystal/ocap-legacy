/*

    ==========================================================================================

    Copyright (C) 2016 Jamie Goodson (aka MisterGoodson) (goodsonjamie@yahoo.co.uk)
                  2020 Andrew Bennett (aka TelluriumCrystal) (admin@andrewbennet1.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    ==========================================================================================

 * Exports supplied capture JSON string into a JSON file.
 * JSON string can (and should) be supplied in multiple separate calls to this extension (as to avoid the Arma buffer limit).
 * This extension also handles transferring of JSON file to either a local or remote (via FTP) location.
 * 
 * Extension argument string can be 1 of 2 forms.
 * f1:
 *     {"write";arg1,json_string_part}
 *     "write" = Tells the extension to write json_string_part to a file (in /tmp)
 *     arg1 = Json filename to write/append to /tmp (e.g. "myfile.json")
 *     json_string_part = Partial json string to be written to a file.
 * f2:
 *     {"transfer";arg1;arg2;arg3;arg4;arg5}
 *     "transfer" = Tells the extension we wish to transfer the json file to a local directory
 *     arg1 = Json filename to move from /tmp (e.g. "myfile.json")
 *     arg2 = World name
 *     arg3 = Mission name
 *     arg4 = Mission duration (seconds)
 *     arg5 = Absolute path to directory where JSON file should be moved to
 */

using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace OCAPExporter
{
    public class Main
    {
        static string logfile = "ocap_log.txt";

        // This 2 line are IMPORTANT and if changed will stop everything working
        // To send a string back to ARMA append to the output StringBuilder, ARMA outputSize limit applies!
        [DllExport("RVExtension", CallingConvention = System.Runtime.InteropServices.CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            // Not sure what this does but I'm afraid to touch it
            outputSize--;

            // Grab arguments from function string (arguments are wrapped in curly brackets).
            // e.g. {arg1;arg2;arg3}restOfFunctionString
            char c = new char();
            int index = 0;
            List<String> args = new List<String>();
            String arg = "";

            // Very crude parser
            // TODO: Use better parser that doesn't break when a '{' or '}' char exists in one of the args
            //Log("Arguments supplied: " + function);
            Log("Parsing arguments...");
            while (c != '}')
            {
                index++;
                c = function[index];

                if (c != ';' && c != '}')
                {
                    arg += c;
                }
                else
                {
                    args.Add(arg);
                    arg = "";
                }
            }
            Log("Done.");

            // Define variables (from args)
            string option = args[0];
            string captureFilename = args[1];
            string tempDir = @"Temp\";
            string captureFilepath = tempDir + captureFilename; // Relative path where capture file will be written to

            // Remove arguments from function string
            function = function.Remove(0, index + 1);

            // Write string to JSON file
            if (option.Equals("write"))
            {
                // Create temp directory if not already exists
                if (!Directory.Exists(tempDir))
                {
                    Log("Temp directory not found, creating...");
                    Directory.CreateDirectory(tempDir);
                    Log("Done.");
                }

                // Create file to write to (if not exists)
                if (!File.Exists(captureFilepath))
                {
                    Log("Capture file not found, creating at " + captureFilepath + "...");
                    File.Create(captureFilepath).Close();
                    Log("Done.");
                }

                // Append to file
                File.AppendAllText(captureFilepath, function);
                Log("Appended capture data to capture file.");

                // Send output to Arma
                output.Append("Success");
            }

            // Export JSON file to local server
            else if (option.Equals("transfer"))
            {
                string worldName = args[2];
                string missionName = args[3];
                string missionDuration = args[4];
                string webRoot = args[5];
                webRoot = AddMissingSlash(webRoot);
                string transferFilepath = webRoot + "data/" + captureFilename;

                try
                {
                    // Move JSON file from /Temp to transferPath
                    Log("Moving " + captureFilename + " to " + transferFilepath + "...");
                    File.Move(captureFilepath, transferFilepath);
                    Log("Done");

                    // Delete original JSON from /Temp
                    Log("Deleting " + captureFilename + " from \\Temp...");
                    File.Delete(captureFilepath);
                    Log("Done");
                }
                catch (Exception e)
                {
                    Log(e.ToString());
                }

                // Send output to Arma
                output.Append("Success");
            }

            // Unknown option passed to .dll
            else
            {
                Log("Unknown option passed from fn_callExtension!");

                // Send output to Arma
                output.Append("Failed");
            }
        }

        public static void Log(string str)
        {
            File.AppendAllText(logfile, DateTime.Now.ToString("dd/MM/yyyy H:mm | ") + str + Environment.NewLine);
            Console.WriteLine(str);
        }

        public static string AddMissingSlash(string str)
        {
            if (!str.EndsWith("/"))
            {
                str += "/";
            }

            return str;
        }
    }
}
