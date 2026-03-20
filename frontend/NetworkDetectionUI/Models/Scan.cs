using System;
using System.Text.Json.Serialization;

public class Scans
{
        [JsonPropertyName("id")]
    public int Id { get; set; }
    [JsonPropertyName("subnet_scanned")]
    public string SubnetScanned { get; set; } = string.Empty;
    [JsonPropertyName("scanned_at")]

    public string ScannedAt { get; set; } = string.Empty;
}