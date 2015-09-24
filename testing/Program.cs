using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

using webapp;

namespace testing
{
    class Program
    {
        static void Main(string[] args)
        {
            Logger.Enabled = true;
            Logger.Verbose = true; 
            Logger.LogFile = @"..\..\log.txt";

            new Thread(logger => {
                for (int i = 0; i < 100000; i++)
                {
                    Logger.Write("message from thread {0} nr.{1}", Thread.CurrentThread, (i + 1));
                }
            }).Start();
            
        }
    }
}
