/*
    ==========================================================================================

    Original work Copyright (C) 2016 Jamie Goodson (aka MisterGoodson) (goodsonjamie@yahoo.co.uk)
    Modified work Copyright (C) 2020 Andrew Bennett (aka TelluriumCrystal) (admin@andrewbennet1.com)

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

    Builds and exports a data file in a custom format to a remote directory. Uses a worker
    thread for file I/O to minimize performance impact.

    Has 4 operating modes specified by the first character passed to the extension. Modes 1
    and 2 will create the temp file if it is not found. Modes 0, 1, and 2 will create the temp
    directory if it is not found.
 
    Operating modes:
    0:  Deletes the temporary file

    1:  Writes the mission head capture string to the temp file. This mode is distinct from
        mode 2 because the Arma 3 scripting engine does not have a means of getting the
        current date and time.

    2:  Writes the passed capture string to the temp file.

    3:  Exports the temp file to the specified directory and with the specified filename. The
        filename and directory are passed in that order delimited by a ';'.
*/

using RGiesecke.DllExport;
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Collections.Generic;
using System.Threading;

namespace OCAPExporter
{
    // Public constants and variables class
    public class Common
    {
        // Constants
        public const string version = "0.7.0";
        public const string logFilePath = "ocap_exporter.log";
        public const string tempDirectory = @"Temp\";
        public const string dataFileExtension = ".data";
        public const string tempFilePath = tempDirectory + "temp" + dataFileExtension;

        // Mutex lock and inter-thread queue
        public static readonly object messageQueueLock = new object();
        public static Queue<string> messageQueue = new Queue<string>();
        public static bool threadSpawned = false;
    }

    // Arma 3 Extension Class (this is what Arma hooks into)
    public class Main
    {
#if WIN64
        [DllExport("RVExtensionVersion", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention = CallingConvention.Winapi)]
#endif
        // Function called by Arma 3 during startup that should return the version number of the extension
        public static void RvExtensionVersion(StringBuilder output, int outputSize)
        {
            if (Common.version.Length <= outputSize)
            {
                output.Append(Common.version);
            }
        }

# if WIN64
        [DllExport("RVExtension", CallingConvention = CallingConvention.Winapi)]
#else
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
#endif
        // Function called by Arma 3 when extension is called in a script
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            // Spawn worker thread if it hasn't already been spawned
            if (!Common.threadSpawned)
            {
                Thread worker = new Thread(new ThreadStart(Worker.FileWriteWorker));
                worker.Start();
                Common.threadSpawned = true;
            }

            // Add data to inter-thread message queue
            lock (Common.messageQueueLock)
            {
                Common.messageQueue.Enqueue(function);
            }
        }
    }

    // Class for worker threads
    public class Worker
    {
        private static FileStream tempFileStream = null;
        private static StreamWriter tempFileWriter = null;
        private static FileStream logFileStream = new FileStream(Common.logFilePath, FileMode.Append);
        private static StreamWriter logFileWriter = new StreamWriter(logFileStream, Encoding.UTF8);
        public static void FileWriteWorker()
        {
            while (true)
            {
                string input = "";

                // Wait until there is something in the inter-thread message queue
                while (input == "")
                {
                    lock (Common.messageQueueLock)
                    {
                        if (Common.messageQueue.Count > 0)
                        {
                            input = Common.messageQueue.Dequeue();
                        }
                    }
                }

                // Strip first char off input to get operating mode
                int opMode = (int)char.GetNumericValue(input[0]);
                input = input.Substring(1);

                // Create temp directory if not already exists
                if (!Directory.Exists(Common.tempDirectory))
                {
                    try
                    {
                        Log("Temp directory not found, creating " + Common.tempDirectory);
                        Directory.CreateDirectory(Common.tempDirectory);
                    }
                    catch (Exception e)
                    {
                        Log(e.ToString());
                        return;
                    }
                }

                switch (opMode)
                {
                    // Delete temporary file
                    case 0:
                        try
                        {
                            // Close stream if open
                            if (tempFileWriter != null)
                            {
                                tempFileWriter.Flush();
                                tempFileStream.Flush();
                                tempFileWriter.Dispose();
                                tempFileStream.Dispose();
                                tempFileWriter = null;
                                tempFileStream = null;
                            }

                            // Delete file
                            Log("Deleting temporary file");
                            File.Delete(Common.tempFilePath);
                        }
                        catch (Exception e)
                        {
                            Log(string.Format("Error: {0}", e.ToString()));
                            return;
                        }
                        break;

                    // Write mission head line to file
                    case 1:
                        string missionDateTime = DateTime.Now.ToString("dd/MM/yyyy H:mm:ss");
                        input += missionDateTime;

                        try
                        {
                            // Create file stream if not open
                            if (tempFileWriter == null)
                            {
                                tempFileStream = new FileStream(Common.tempFilePath, FileMode.Create);
                                tempFileWriter = new StreamWriter(tempFileStream, Encoding.UTF8);
                            }

                            // Write to file
                            tempFileWriter.WriteLine(input);
                        }
                        catch (Exception e)
                        {
                            Log(e.ToString());
                            return;
                        }
                        break;

                    // Write single line to file
                    case 2:
                        try
                        {
                            // Create file stream if not open
                            if (tempFileWriter == null)
                            {
                                tempFileStream = new FileStream(Common.tempFilePath, FileMode.Create);
                                tempFileWriter = new StreamWriter(tempFileStream, Encoding.UTF8);
                            }

                            // Write to file
                            tempFileWriter.WriteLine(input);
                        }
                        catch (Exception e)
                        {
                            Log(e.ToString());
                            return;
                        }
                        break;

                    // Export temporary file to specified path
                    case 3:

                        // Parse information from input
                        string[] args = input.Split(';');
                        string transferFilename = args[0];
                        string transferDirectory = args[1];

                        // Handle missing "/"
                        if (transferDirectory[transferDirectory.Length - 1] != '\\' || transferDirectory[transferDirectory.Length - 1] != '/')
                        {
                            transferDirectory += '\\';
                        }

                        string transferFilePath = transferDirectory + transferFilename + Common.dataFileExtension;

                        try
                        {

                            // Close stream if open
                            if (tempFileWriter != null)
                            {
                                tempFileWriter.Flush();
                                tempFileStream.Flush();
                                tempFileWriter.Dispose();
                                tempFileStream.Dispose();
                                tempFileWriter = null;
                                tempFileStream = null;
                            }

                            // Check if data file with same name already exists at export directory
                            if (File.Exists(transferFilePath))
                            {
                                Log(transferFilePath + " already exists!");

                                // Keep incrementing a suffix number until an unused filename is found
                                int suffix = 0;
                                do
                                {
                                    suffix++;
                                    transferFilePath = transferDirectory + transferFilename + "_" + suffix + Common.dataFileExtension;
                                } while (File.Exists(transferFilePath));
                                Log("Will rename the file to " + Path.GetFileName(transferFilePath));
                            }

                            // Move file from temp directory to remote directory
                            Log("Moving " + Common.tempFilePath + " to " + transferFilePath);
                            File.Move(Common.tempFilePath, transferFilePath);
                        }
                        catch (Exception e)
                        {
                            Log(e.ToString());
                        }
                        break;

                    // All other opModes are erronous
                    default:
                        Log(string.Format("Exporter passed invalid opMode {0}", opMode));
                        break;
                }
            }
        }

        private static void Log(string str)
        {
            logFileWriter.WriteLine(DateTime.Now.ToString("dd/MM/yyyy H:mm:ss | ") + str);
            logFileWriter.Flush();
            Console.WriteLine(str);
        }
    }
}
