using System;
using System.Text.Json.Serialization;

public class Logs
{
    [JsonPropertyName("id")]
    public int Id { get; set; }
    [JsonPropertyName("event")]
    public string Event { get; set; } = string.Empty;
    [JsonPropertyName("created_at")]
    public string CreatedAt { get; set; } = string.Empty;
}