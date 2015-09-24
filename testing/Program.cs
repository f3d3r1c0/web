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
            Logger.Verbose = false; 
            Logger.LogFile = @"..\..\log.txt";

            Logger.Write("starting ...");

            for (int k = 1; k <= 5; k++)
            {
                new Thread(logger =>
                {
                    for (int i = 0; i < 10000; i++)
                    {
                        Logger.Write("message nr.{0}", (i + 1));
                    }
                    Console.WriteLine("thread {0} exit ...", k);
                }).Start();
            }
            
        }
    }
}
