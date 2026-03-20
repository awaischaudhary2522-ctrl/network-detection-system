using System.Collections.Generic;
using System.Text.Json.Serialization;

public class ScanResult
{
    [JsonPropertyName("devices")]
    public List<Devices> Devices { get; set; } = new List<Devices>();
    [JsonPropertyName("ports")]
    public List<ScanPorts> Ports { get; set; } = new List<ScanPorts>();

}