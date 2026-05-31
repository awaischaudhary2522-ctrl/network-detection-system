using Avalonia.Media;
using System;
using System.Globalization;

namespace NetworkDetectionUI.Converters;

public class SeverityColorConverter : Avalonia.Data.Converters.IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        var severity = value?.ToString() ?? "";
        return severity.ToLower() switch
        {
            "critical" => new SolidColorBrush(Color.Parse("#E53935")),
            "high" => new SolidColorBrush(Color.Parse("#FB8C00")),
            "medium" => new SolidColorBrush(Color.Parse("#FDD835")),
            "low" => new SolidColorBrush(Color.Parse("#43A047")),
            "info" => new SolidColorBrush(Color.Parse("#78909C")),
            _ => new SolidColorBrush(Color.Parse("#78909C")),
        };
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        throw new NotSupportedException();
    }
}
