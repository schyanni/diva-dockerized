using System;
using System.Net;

namespace HttpPostRequest
{
    public class PostReq
    {
        public string SendPostRequest(string url, string requestBody)
        {
            Console.WriteLine("You startet Post function");
            // Create a new request to the specified URL
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

            // Set the method to POST
            request.Method = "POST";

            // Set the content type and content length
            request.ContentType = "application/x-www-form-urlencoded";
            byte[] requestData = System.Text.Encoding.UTF8.GetBytes(requestBody);
            request.ContentLength = requestData.Length;

            // Write the request body
            System.IO.Stream requestStream = request.GetRequestStream();
            requestStream.Write(requestData, 0, requestData.Length);
            requestStream.Close();

            // Send the request and get the response
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            // Get the response stream
            System.IO.StreamReader streamReader = new System.IO.StreamReader(response.GetResponseStream());

            // Read the response and return it as a string
            return streamReader.ReadToEnd();
        }
    }
}
