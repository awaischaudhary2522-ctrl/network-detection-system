using Avalonia.Media;
using System;
using System.Globalization;

namespace NetworkDetectionUI.Converters;

public class BoolToResolvedConverter : Avalonia.Data.Converters.IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is bool resolved)
        {
            return resolved
                ? new SolidColorBrush(Color.Parse("#43A047"))
                : new SolidColorBrush(Color.Parse("#E53935"));
        }
        return new SolidColorBrush(Color.Parse("#78909C"));
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        throw new NotSupportedException();
    }
}
