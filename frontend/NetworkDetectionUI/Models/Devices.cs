using System;
using System.Text.Json.Serialization;

public class Devices
{
        [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("ip_address")]

    public string IpAddress { get; set; } = string.Empty;
    [JsonPropertyName("hostname")]
    public string Hostname { get; set; } = string.Empty;
    [JsonPropertyName("mac_address")]
    public string MacAddress { get; set; } = string.Empty;
    [JsonPropertyName("first_seen")]
    public string FirstSeen { get; set; } = string.Empty;
    [JsonPropertyName("last_seen")]
    public string LastSeen { get; set; } = string.Empty;
}