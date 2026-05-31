using System;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

public class ApiResponse<T>
{
    [JsonPropertyName("data")]
    public List<T> Data { get; set; } = new List<T>();
    [JsonPropertyName("total")]
    public int Total { get; set; }
    [JsonPropertyName("page")]
    public int Page { get; set; }
    [JsonPropertyName("per_page")]
    public int PerPage { get; set; }
}

public class ApiService
{
    private readonly HttpClient _client = new HttpClient { Timeout = TimeSpan.FromMinutes(10) };
    private const string BaseUrl = "http://localhost:5000";

    public async Task<(List<T> data, int total)> GetPaginated<T>(string endpoint, int page = 1, int perPage = 50, string search = "")
    {
        var url = $"{BaseUrl}{endpoint}?page={page}&per_page={perPage}";
        if (!string.IsNullOrEmpty(search))
            url += $"&search={Uri.EscapeDataString(search)}";

        var response = await _client.GetAsync(url);
        var content = await response.Content.ReadAsStringAsync();
        var result = JsonSerializer.Deserialize<ApiResponse<T>>(content);

        if (result != null)
            return (result.Data, result.Total);

        return (new List<T>(), 0);
    }

    public async Task<List<T>> GetAll<T>(string endpoint)
    {
        var (data, _) = await GetPaginated<T>(endpoint, 1, 999999);
        return data;
    }

    public async Task<(List<Devices> data, int total)> GetDevices(int page = 1, int perPage = 50, string search = "")
    {
        return await GetPaginated<Devices>("/devices", page, perPage, search);
    }

    public async Task<(List<Ports> data, int total)> GetPorts(int page = 1, int perPage = 50, string search = "")
    {
        return await GetPaginated<Ports>("/ports", page, perPage, search);
    }

    public async Task<(List<Alerts> data, int total)> GetAlerts(int page = 1, int perPage = 50, string search = "")
    {
        return await GetPaginated<Alerts>("/alerts", page, perPage, search);
    }

    public async Task<(List<Logs> data, int total)> GetLogs(int page = 1, int perPage = 50)
    {
        return await GetPaginated<Logs>("/logs", page, perPage);
    }

    public async Task<(List<Scans> data, int total)> GetScans(int page = 1, int perPage = 50)
    {
        return await GetPaginated<Scans>("/scans", page, perPage);
    }

    public async Task<ScanResult> Scan(string ip)
    {
        var response = await _client.GetAsync($"{BaseUrl}/scan?ip={ip}");
        var content = await response.Content.ReadAsStringAsync();
        if (!response.IsSuccessStatusCode)
        {
            var error = JsonSerializer.Deserialize<Dictionary<string, object>>(content);
            var msg = error?.GetValueOrDefault("error", "Scan failed")?.ToString() ?? "Scan failed";
            throw new Exception(msg);
        }
        return JsonSerializer.Deserialize<ScanResult>(content) ?? new ScanResult();
    }

    public async Task ResolveAlert(int alertId, bool resolved)
    {
        var body = new { resolved };
        var json = JsonSerializer.Serialize(body);
        var httpContent = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
        await _client.PatchAsync($"{BaseUrl}/alerts/{alertId}", httpContent);
    }

    public async Task<bool> CheckHealth()
    {
        try
        {
            var response = await _client.GetAsync($"{BaseUrl}/health");
            return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    public async Task<string> DownloadCsv(string endpoint)
    {
        var response = await _client.GetAsync($"{BaseUrl}/export/{endpoint}");
        return await response.Content.ReadAsStringAsync();
    }
}
