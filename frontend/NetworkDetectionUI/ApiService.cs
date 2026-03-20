using System;
using System.Text.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;
public class ApiService
{
    public async Task<List<Devices>> GetDevices()
    {
        var client = new HttpClient();
        var response = await client.GetAsync("http://localhost:5000/devices");
        var content = await response.Content.ReadAsStringAsync();
        var devices = JsonSerializer.Deserialize<List<Devices>>(content) ?? new List<Devices>();
        return devices;
    }

    public async Task<List<Ports>> GetPorts()
    {
        var client = new HttpClient();
        var response = await client.GetAsync("http://localhost:5000/ports");
        var content = await response.Content.ReadAsStringAsync();
        var ports = JsonSerializer.Deserialize<List<Ports>>(content) ?? new List<Ports>();
        return ports;
    }

    public async Task<List<Alerts>> GetAlerts()
    {
        var client = new HttpClient();
        var response = await client.GetAsync("http://localhost:5000/alerts");
        var content = await response.Content.ReadAsStringAsync();
        var alerts = JsonSerializer.Deserialize<List<Alerts>>(content) ?? new List<Alerts>();
        return alerts;
    }

    public async Task<List<Logs>> GetLogs()
    {
        var client = new HttpClient();
        var response = await client.GetAsync("http://localhost:5000/logs");
        var content = await response.Content.ReadAsStringAsync();
        var logs = JsonSerializer.Deserialize<List<Logs>>(content) ?? new List<Logs>();
        return logs;
    }

    public async Task<List<Scans>> GetScans()
    {
        var client = new HttpClient();
        var response = await client.GetAsync("http://localhost:5000/scans");
        var content = await response.Content.ReadAsStringAsync();
        var scans = JsonSerializer.Deserialize<List<Scans>>(content) ?? new List<Scans>();
        return scans;
    }

    public async Task<ScanResult> Scan(string ip)
    {
        var client = new HttpClient();
        client.Timeout = TimeSpan.FromMinutes(5);
        var response = await client.GetAsync("http://localhost:5000/scan?ip=" + ip);
        var content = await response.Content.ReadAsStringAsync();
        var result = JsonSerializer.Deserialize<ScanResult>(content) ?? new ScanResult();
        return result;
    }
}