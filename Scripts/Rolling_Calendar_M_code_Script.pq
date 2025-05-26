let
    StartDate = #date(2014, 1, 1),
    EndDate = Date.From(DateTime.LocalNow()),
    DatesList = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    CalendarTable = Table.FromList(DatesList, Splitter.SplitByNothing(), {"Date"}),
    #"Inserted Year" = Table.AddColumn(CalendarTable, "Year", each Date.Year([Date]), Int64.Type),
    #"Inserted Quarter" = Table.AddColumn(#"Inserted Year", "Quarter", each Date.QuarterOfYear([Date]), Int64.Type),
    #"Added Prefix" = Table.TransformColumns(#"Inserted Quarter", {{"Quarter", each "Q" & Text.From(_, "en-US"), type text}}),
    #"Inserted Month Name" = Table.AddColumn(#"Added Prefix", "Month Name", each Date.MonthName([Date]), type text),
    #"Inserted Week of Month" = Table.AddColumn(#"Inserted Month Name", "Week of Month", each Date.WeekOfMonth([Date]), Int64.Type),
    #"Inserted Day of Year" = Table.AddColumn(#"Inserted Week of Month", "Day of Year", each Date.DayOfYear([Date]), Int64.Type),
    #"Inserted Day Name" = Table.AddColumn(#"Inserted Day of Year", "Day Name", each Date.DayOfWeekName([Date]), type text),
    #"Changed Type" = Table.TransformColumnTypes(#"Inserted Day Name",{{"Date", type date}, {"Year", Int64.Type}, {"Quarter", type text}, {"Month Name", type text}, {"Week of Month", Int64.Type}, {"Day of Year", Int64.Type}, {"Day Name", type text}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Changed Type", {{"Date", type date}}, "en-IN")
in
    #"Changed Type with Locale"