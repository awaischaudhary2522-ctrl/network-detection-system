using System;
using System.Text.Json.Serialization;

public class Ports
{
        [JsonPropertyName("id")]
    public int Id { get; set; }
    [JsonPropertyName("device_id")]
    public int DeviceId { get; set; }
    [JsonPropertyName("scan_id")]
    public int ScanId { get; set; }
    [JsonPropertyName("port_number")]
    public int PortNumber { get; set; }
    [JsonPropertyName("service_name")]
    public string ServiceName { get; set; } = string.Empty;
    [JsonPropertyName("protocol")]
    public string Protocol { get; set; } = string.Empty;
}