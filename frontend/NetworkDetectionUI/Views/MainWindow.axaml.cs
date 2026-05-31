using Avalonia.Controls;
using Avalonia.Input;
using NetworkDetectionUI.ViewModels;

namespace NetworkDetectionUI.Views;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    private void OnKeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key == Key.Enter)
        {
            var vm = DataContext as MainWindowViewModel;
            vm?.StartScanCommand.Execute(null);
        }
    }
}