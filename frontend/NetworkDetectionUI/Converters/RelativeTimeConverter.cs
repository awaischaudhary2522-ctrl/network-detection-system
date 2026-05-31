using System;
using System.Globalization;

namespace NetworkDetectionUI.Converters;

public class RelativeTimeConverter : Avalonia.Data.Converters.IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is not string dateStr || string.IsNullOrEmpty(dateStr))
            return "N/A";

        if (!DateTime.TryParse(dateStr, out var date))
            return dateStr;

        var span = DateTime.Now - date;

        if (span.TotalMinutes < 1) return "Just now";
        if (span.TotalMinutes < 60) return $"{(int)span.TotalMinutes}m ago";
        if (span.TotalHours < 24) return $"{(int)span.TotalHours}h ago";
        if (span.TotalDays < 7) return $"{(int)span.TotalDays}d ago";
        return date.ToString("MMM dd, yyyy");
    }

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        throw new NotSupportedException();
    }
}
