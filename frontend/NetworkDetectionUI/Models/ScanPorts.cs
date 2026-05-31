using System;
using System.Text.Json.Serialization;

public class ScanPorts
{

    [JsonPropertyName("ip_address")]
    public string IpAddress { get; set; } = string.Empty;

    [JsonPropertyName("device_id")]
    public int DeviceId { get; set; }
    [JsonPropertyName("port_number")]
    public int PortNumber { get; set; }
    [JsonPropertyName("service_name")]
    public string ServiceName { get; set; } = string.Empty;
    [JsonPropertyName("protocol")]
    public string Protocol { get; set; } = string.Empty;
}