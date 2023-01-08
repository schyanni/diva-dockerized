using HttpGetRequest;
using HttpPostRequest;
using System;
using System.Net;

namespace HttpServer
{
    class Program
    {
        static void Main(string[] args)
        {
            // Create a new HttpListener object
            HttpListener listener = new HttpListener();
            GetReq GetRequest = new GetReq();
            PostReq PostRequest = new PostReq();

            // Add the prefixes that the server should listen for
            listener.Prefixes.Add("http://localhost:8080/");
            string url = "http://localhost:8080/";
            string requestBody = "param1=value1&param2=value2";

            // Start the listener
            listener.Start();

            Console.WriteLine("Listening for requests on port 8080...");


            //GetRequest.SendGetRequest(url);
            PostRequest.SendPostRequest(url, requestBody);

            // Wait for a request
            HttpListenerContext context = listener.GetContext();


            // Get the request and response objects
            HttpListenerRequest request = context.Request;
            HttpListenerResponse response = context.Response;


            // Check the request method
            if (request.HttpMethod == "GET")
            {
                // Handle the GET request
                // Set the response status code and content type
                response.StatusCode = 200;
                response.ContentType = "text/plain";

                // Write the response body
                string responseString = "You sent a GET request";
                Console.WriteLine("You sent a GET request");
                byte[] buffer = System.Text.Encoding.UTF8.GetBytes(responseString);
                response.ContentLength64 = buffer.Length;
                System.IO.Stream output = response.OutputStream;
                output.Write(buffer, 0, buffer.Length);
            }
            else if (request.HttpMethod == "POST")
            {
                // Handle the POST request
                // Set the response status code and content type
                response.StatusCode = 200;
                response.ContentType = "text/plain";

                // Read the request body
                System.IO.Stream input = request.InputStream;
                int length = (int)input.Length;
                byte[] data = new byte[length];
                input.Read(data, 0, length);
                input.Close();

                // Write the response body
                string responseString = "You sent a POST request: " + System.Text.Encoding.UTF8.GetString(data);
                Console.WriteLine("You sent a POST request: " + System.Text.Encoding.UTF8.GetString(data));
                byte[] buffer = System.Text.Encoding.UTF8.GetBytes(responseString);
                response.ContentLength64 = buffer.Length;
                System.IO.Stream output = response.OutputStream;
                output.Write(buffer, 0, buffer.Length);
            }

            // Close the output stream and the listener
            //output.Close();
            listener.Stop();
        }
    }
}
