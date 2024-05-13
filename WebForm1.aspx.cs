using Newtonsoft.Json;
using System;
using System.Net.Http;

namespace currencyExchanger
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected async void btnSearch_Click(object sender, EventArgs e)
        {
            string currencyToExchange = txtExchangeRate.Text; //currency to exchange
            string currencyFromExchange = txtExchangeRate0.Text; //currency to exchange to

            string API_KEY = "";

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    // Make an HTTP GET request to an API to get exchange rate data
                    HttpResponseMessage response = await client.GetAsync($"https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency={currencyToExchange}&to_currency={currencyFromExchange}&apikey={API_KEY}");

                    // Check if the response is successful
                    if (response.IsSuccessStatusCode)
                    {
                        // Read the content of the response as a string
                        string responseBody = await response.Content.ReadAsStringAsync();

                        // Deserialize the JSON response into a dynamic object
                        dynamic jsonResponse = JsonConvert.DeserializeObject(responseBody);

                        // Access the properties of the dynamic object to get the exchange rate information
                        string fromCurrencyCode = jsonResponse["Realtime Currency Exchange Rate"]["1. From_Currency Code"];
                        string fromCurrencyName = jsonResponse["Realtime Currency Exchange Rate"]["2. From_Currency Name"];
                        string toCurrencyCode = jsonResponse["Realtime Currency Exchange Rate"]["3. To_Currency Code"];
                        string toCurrencyName = jsonResponse["Realtime Currency Exchange Rate"]["4. To_Currency Name"];
                        string exchangeRate = jsonResponse["Realtime Currency Exchange Rate"]["5. Exchange Rate"];
                        string lastRefreshed = jsonResponse["Realtime Currency Exchange Rate"]["6. Last Refreshed"];
                        string timeZone = jsonResponse["Realtime Currency Exchange Rate"]["7. Time Zone"];
                        string bidPrice = jsonResponse["Realtime Currency Exchange Rate"]["8. Bid Price"];
                        string askPrice = jsonResponse["Realtime Currency Exchange Rate"]["9. Ask Price"];

                        // Format the exchange rate information
                        string formattedExchangeRate = $"From: {fromCurrencyName} ({fromCurrencyCode})\n" +
                                                        $"To: {toCurrencyName} ({toCurrencyCode})\n" +
                                                        $"Exchange Rate: {exchangeRate}\n" +
                                                        $"Last Refreshed: {lastRefreshed}\n" +
                                                        $"Time Zone: {timeZone}\n" +
                                                        $"Bid Price: {bidPrice}\n" +
                                                        $"Ask Price: {askPrice}";

                        // For example, you could set the text of a label to the exchange rate
                        lblExchangeRate.Text = formattedExchangeRate;
                    }
                    else
                    {
                        // If the request was not successful, display an error message
                        lblExchangeRate.Text = "Failed to retrieve exchange rate data";
                    }
                }
                catch (Exception ex)
                {
                    // If an exception occurs, display the exception message
                    lblExchangeRate.Text = $"Exception: {ex.Message}";
                }
            }
        }
    }
}
