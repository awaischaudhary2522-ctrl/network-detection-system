using System;
using System.Text.Json.Serialization;

public class Alerts
{
        [JsonPropertyName("id")]
    public int Id { get; set; }
    [JsonPropertyName("alert_type")]
    public string AlertType { get; set; } = string.Empty;
    [JsonPropertyName("severity")]
    public string Severity { get; set; } = string.Empty;
    [JsonPropertyName("source_ip")]
    public string SourceIp { get; set; } = string.Empty;
    [JsonPropertyName("created_at")]
    public string CreatedAt { get; set; } = string.Empty;
    [JsonPropertyName("resolved")]
    public bool Resolved { get; set; }
}