using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Avalonia.Media;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace NetworkDetectionUI.ViewModels;

public partial class MainWindowViewModel : ViewModelBase
{
    [ObservableProperty]
    private string _ipInput = string.Empty;
    [ObservableProperty]
    private string _scanStatus = string.Empty;
    [ObservableProperty]
    private bool _isScanning;

    [ObservableProperty]
    private List<Devices> _devices = new();
    [ObservableProperty]
    private List<Devices> _currentScanDevices = new();
    [ObservableProperty]
    private List<Devices> _displayedDevices = new();

    [ObservableProperty]
    private List<Ports> _ports = new();
    [ObservableProperty]
    private List<ScanPorts> _currentScanPorts = new();
    [ObservableProperty]
    private List<ScanPorts> _displayedScanPorts = new();

    [ObservableProperty]
    private List<Alerts> _alerts = new();
    [ObservableProperty]
    private List<Alerts> _currentScanAlerts = new();
    [ObservableProperty]
    private List<Alerts> _displayedAlerts = new();

    [ObservableProperty]
    private List<Logs> _logs = new();
    [ObservableProperty]
    private List<Scans> _scans = new();

    [ObservableProperty]
    private string _deviceSearch = string.Empty;
    [ObservableProperty]
    private string _portSearch = string.Empty;
    [ObservableProperty]
    private string _alertSearch = string.Empty;

    [ObservableProperty]
    private string _connectionStatusText = "Connecting...";
    [ObservableProperty]
    private ISolidColorBrush _connectionStatusColor = new SolidColorBrush(Color.Parse("#78909C"));
    [ObservableProperty]
    private string _deviceCountText = "0 devices";
    [ObservableProperty]
    private string _openAlertCountText = "0";
    [ObservableProperty]
    private string _totalAlertCountText = "0";
    [ObservableProperty]
    private string _lastScanText = "No scans yet";
    [ObservableProperty]
    private string _lastScanTime = "Last scan: never";

    private readonly ApiService _api = new();

    public MainWindowViewModel()
    {
        _ = InitializeAsync();
    }

    private async Task InitializeAsync()
    {
        _ = CheckHealthLoop();
        await LoadAllData();
    }

    private async Task CheckHealthLoop()
    {
        while (true)
        {
            var healthy = await _api.CheckHealth();
            if (healthy)
            {
                ConnectionStatusText = "Connected";
                ConnectionStatusColor = new SolidColorBrush(Color.Parse("#43A047"));
            }
            else
            {
                ConnectionStatusText = "Disconnected";
                ConnectionStatusColor = new SolidColorBrush(Color.Parse("#E53935"));
            }
            await Task.Delay(5000);
        }
    }

    private async Task LoadAllData()
    {
        await LoadDevices();
        await LoadPorts();
        await LoadAlerts();
        await LoadLogs();
        await LoadScans();
        UpdateStatusBar();
    }

    private void UpdateStatusBar()
    {
        DeviceCountText = $"{Devices.Count} devices";
        OpenAlertCountText = $"{Alerts.Count(a => !a.Resolved)}";
        TotalAlertCountText = $"{Alerts.Count}";
        if (Scans.Count > 0)
        {
            var last = Scans.OrderByDescending(s => s.Id).First();
            LastScanTime = $"Last scan: {last.SubnetScanned}";
            LastScanText = $"{last.SubnetScanned}";
        }
    }

    public async Task LoadDevices()
    {
        try
        {
            var (data, _) = await _api.GetDevices(1, 999999);
            Devices = data;
            DisplayedDevices = data;
        }
        catch (Exception ex)
        {
            ScanStatus = "Error loading devices: " + ex.Message;
        }
    }

    public async Task LoadPorts()
    {
        try
        {
            var (data, _) = await _api.GetPorts(1, 999999);
            Ports = data;
        }
        catch (Exception ex)
        {
            ScanStatus = "Error loading ports: " + ex.Message;
        }
    }

    public async Task LoadAlerts()
    {
        try
        {
            var (data, _) = await _api.GetAlerts(1, 999999);
            Alerts = data;
            DisplayedAlerts = data;
        }
        catch (Exception ex)
        {
            ScanStatus = "Error loading alerts: " + ex.Message;
        }
    }

    public async Task LoadLogs()
    {
        try
        {
            var (data, _) = await _api.GetLogs(1, 100);
            Logs = data;
        }
        catch (Exception ex)
        {
            ScanStatus = "Error loading logs: " + ex.Message;
        }
    }

    public async Task LoadScans()
    {
        try
        {
            var (data, _) = await _api.GetScans(1, 100);
            Scans = data;
        }
        catch (Exception ex)
        {
            ScanStatus = "Error loading scans: " + ex.Message;
        }
    }

    [RelayCommand]
    public async Task StartScan()
    {
        if (string.IsNullOrEmpty(IpInput))
        {
            ScanStatus = "Please enter an IP range";
            return;
        }
        try
        {
            IsScanning = true;
            ScanStatus = "Scanning...";
            int alertsBefore = Alerts.Count;

            var result = await _api.Scan(IpInput);

            CurrentScanDevices = result.Devices;
            DisplayedDevices = CurrentScanDevices;
            CurrentScanPorts = result.Ports;
            DisplayedScanPorts = CurrentScanPorts;

            await LoadAlerts();
            CurrentScanAlerts = Alerts.Skip(alertsBefore).ToList();
            DisplayedAlerts = CurrentScanAlerts;
            await LoadAllData();

            ScanStatus = $"Scan complete — {CurrentScanDevices.Count} devices found";
        }
        catch (Exception ex)
        {
            ScanStatus = "Error: " + ex.Message;
        }
        finally
        {
            IsScanning = false;
        }
    }

    [RelayCommand]
    public void ShowCurrentScan()
    {
        DisplayedDevices = CurrentScanDevices;
    }

    [RelayCommand]
    public void ShowAllDevices()
    {
        DisplayedDevices = Devices;
    }

    [RelayCommand]
    public void ShowCurrentScanPorts()
    {
        DisplayedScanPorts = CurrentScanPorts;
    }

    [RelayCommand]
    public void ShowAllPorts()
    {
        DisplayedScanPorts = Ports.Select(p => new ScanPorts
        {
            DeviceId = p.DeviceId,
            IpAddress = string.Empty,
            PortNumber = p.PortNumber,
            ServiceName = p.ServiceName,
            Protocol = p.Protocol
        }).ToList();
    }

    [RelayCommand]
    public void ShowCurrentScanAlerts()
    {
        DisplayedAlerts = CurrentScanAlerts;
    }

    [RelayCommand]
    public void ShowAllAlerts()
    {
        DisplayedAlerts = Alerts;
    }

    [RelayCommand]
    public async Task ResolveAlert(Alerts alert)
    {
        if (alert == null) return;
        await _api.ResolveAlert(alert.Id, !alert.Resolved);
        alert.Resolved = !alert.Resolved;
        await LoadAlerts();
        UpdateStatusBar();
    }

    [RelayCommand]
    public async Task ExportDevices()
    {
        try
        {
            var csv = await _api.DownloadCsv("devices");
            ScanStatus = $"Exported {Devices.Count} devices";
        }
        catch (Exception ex)
        {
            ScanStatus = "Export error: " + ex.Message;
        }
    }

    [RelayCommand]
    public async Task ExportPorts()
    {
        try
        {
            var csv = await _api.DownloadCsv("ports");
            ScanStatus = $"Exported ports";
        }
        catch (Exception ex)
        {
            ScanStatus = "Export error: " + ex.Message;
        }
    }

    [RelayCommand]
    public async Task ExportAlerts()
    {
        try
        {
            var csv = await _api.DownloadCsv("alerts");
            ScanStatus = $"Exported alerts";
        }
        catch (Exception ex)
        {
            ScanStatus = "Export error: " + ex.Message;
        }
    }

    partial void OnDeviceSearchChanged(string value)
    {
        if (string.IsNullOrEmpty(value))
            DisplayedDevices = Devices;
        else
            DisplayedDevices = Devices
                .Where(d => d.IpAddress.Contains(value, StringComparison.OrdinalIgnoreCase)
                         || d.Hostname.Contains(value, StringComparison.OrdinalIgnoreCase))
                .ToList();
    }

    partial void OnPortSearchChanged(string value)
    {
        if (string.IsNullOrEmpty(value))
            DisplayedScanPorts = CurrentScanPorts;
        else
            DisplayedScanPorts = CurrentScanPorts
                .Where(p => p.ServiceName.Contains(value, StringComparison.OrdinalIgnoreCase)
                         || p.PortNumber.ToString().Contains(value))
                .ToList();
    }

    partial void OnAlertSearchChanged(string value)
    {
        if (string.IsNullOrEmpty(value))
            DisplayedAlerts = Alerts;
        else
            DisplayedAlerts = Alerts
                .Where(a => a.AlertType.Contains(value, StringComparison.OrdinalIgnoreCase)
                         || a.SourceIp.Contains(value, StringComparison.OrdinalIgnoreCase))
                .ToList();
    }
}
