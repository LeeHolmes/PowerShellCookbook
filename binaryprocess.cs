using System;
using System.IO;

public class BinaryProcess
{
    public static void Main(string[] args)
    {
        if(args[0] == "-consume")
        {
            using(Stream inputStream = Console.OpenStandardInput())
            {
                for(byte counter = 0; counter < 255; counter++)
                {
                    byte received = (byte) inputStream.ReadByte();
                    if(received != counter)
                    {
                        Console.WriteLine(
                            "Got an invalid byte: {0}, expected {1}.",
                            received, counter);
                        return;
                    }
                    else
                    {
                        Console.WriteLine(
                            "Properly received byte: {0}.", received, counter);
                    }
                }
            }
        }

        if(args[0] == "-emit")
        {
            using(Stream outputStream = Console.OpenStandardOutput())
            {
                for(byte counter = 0; counter < 255; counter++)
                {
                    outputStream.WriteByte(counter);
                }
            }
        }
    }
}