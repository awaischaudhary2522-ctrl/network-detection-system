using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System.Linq;

namespace NetworkDetectionUI.ViewModels;

public partial class MainWindowViewModel : ViewModelBase
{


    [ObservableProperty]
    private string _ipInput = string.Empty;
    [ObservableProperty]
    private string _scanStatus = string.Empty;
    [ObservableProperty]
    private List<Devices> _devices = new List<Devices>();
    [ObservableProperty]
    private List<Devices> _currentScanDevices = new List<Devices>();
    [ObservableProperty]
    private List<Ports> _ports = new List<Ports>();
    [ObservableProperty]
    private List<ScanPorts> _displayedScanPorts = new List<ScanPorts>();
    [ObservableProperty]
    private List<ScanPorts> _currentScanPorts = new List<ScanPorts>();
    [ObservableProperty]
    private List<Alerts> _alerts = new List<Alerts>();
    [ObservableProperty]
    private List<Alerts> _currentScanAlerts = new List<Alerts>();
    [ObservableProperty]
    private List<Alerts> _displayedAlerts = new List<Alerts>();
    [ObservableProperty]
    private List<Logs> _logs = new List<Logs>();
    [ObservableProperty]
    private List<Scans> _scans = new List<Scans>();
    [ObservableProperty]
    private bool _showingCurrentScan = false;
    [ObservableProperty]
    private List<Devices> _displayedDevices = new List<Devices>();
    private ApiService _apiService = new ApiService();

    public MainWindowViewModel()
    {
        _ = LoadDevices();
        _ = LoadPorts();
        _ = LoadAlerts();
        _ = LoadLogs();
        _ = LoadScans();
    }

    public async Task LoadDevices()
    {
        try
        {
            Devices = await _apiService.GetDevices();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }
    public async Task LoadPorts()
    {
        try
        {
            Ports = await _apiService.GetPorts();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }

    public async Task LoadAlerts()
    {
        try
        {
            Alerts = await _apiService.GetAlerts();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }

    public async Task LoadLogs()
    {
        try
        {
            Logs = await _apiService.GetLogs();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }

    public async Task LoadScans()
    {
        try
        {
            Scans = await _apiService.GetScans();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }

    [RelayCommand]
    public async Task StartScan()
    {
        if (IpInput == "")
        {
            ScanStatus = "Please enter an IP range";
            return;
        }
        try
        {
            int alertsBefore = Alerts.Count;
            ScanStatus = "Scanning...";
            var result = await _apiService.Scan(IpInput);
            CurrentScanDevices = result.Devices;
            DisplayedDevices = CurrentScanDevices;
            CurrentScanPorts = result.Ports;
            DisplayedScanPorts = CurrentScanPorts;
            // ... scan happens ...
            await LoadAlerts();
            CurrentScanAlerts = Alerts.Skip(alertsBefore).ToList();
            DisplayedAlerts = CurrentScanAlerts;
            // Ports = result.Ports;
            await LoadDevices();
            await LoadPorts();
            await LoadScans();
            await LoadAlerts();
            await LoadLogs();
            ScanStatus = $"Scan Complete — {CurrentScanDevices.Count} devices found";
            Console.WriteLine($"Devices from scan: {result.Devices.Count}");
            Console.WriteLine($"Ports from scan: {result.Ports.Count}");
        }
        catch (Exception ex)
        {
            ScanStatus = "Error: " + ex.Message;
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
}
