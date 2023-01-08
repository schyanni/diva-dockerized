using System;
using System.Net;

namespace HttpGetRequest
{
    public class GetReq
    {
        public string SendGetRequest(string url)
        {
            Console.WriteLine("You startet get function");
            // Create a new request to the specified URL
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

            // Set the method to GET
            request.Method = "GET";

            // Send the request and get the response
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            // Get the response stream
            System.IO.StreamReader streamReader = new System.IO.StreamReader(response.GetResponseStream());

            // Read the response and return it as a string
            return streamReader.ReadToEnd();
        }
    }
}
