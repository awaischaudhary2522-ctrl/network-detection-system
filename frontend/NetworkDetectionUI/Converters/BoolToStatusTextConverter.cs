using System;
using System.Globalization;

namespace NetworkDetectionUI.Converters;

public class BoolToStatusTextConverter : Avalonia.Data.Converters.IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is bool resolved)
            return resolved ? "Resolved" : "Open";
        return "Unknown";
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        throw new NotSupportedException();
    }
}
