let fnDateTableRus = (#"Дата начала" as date, #"Дата окончания" as date) as table =>
  let
    DayCount = Duration.Days(Duration.From(#"Дата окончания" - #"Дата начала"))+1,
    Source = List.Dates(#"Дата начала",DayCount,#duration(1,0,0,0)),
    TableFromList = Table.FromList(Source, Splitter.SplitByNothing()),    
    ChangedType = Table.TransformColumnTypes(TableFromList,{{"Column1", type date}}),
    RenamedColumns = Table.RenameColumns(ChangedType,{{"Column1", "Дата"}}),
    InsertYear = Table.AddColumn(RenamedColumns, "Год", each Date.Year([Дата]),type text),
    InsertQuarterNum = Table.AddColumn(InsertYear, "Номер квартала", each Date.QuarterOfYear([Дата])),
    InsertQuarter = Table.AddColumn(InsertQuarterNum, "Квартал", each "Кв." & Number.ToText([Номер квартала])),
    InsertMonth = Table.AddColumn(InsertQuarter, "Номер месяца", each Date.Month([Дата]), Int64.Type),
    InsertStartOfMonth = Table.AddColumn(InsertMonth, "Начало месяца", each Date.StartOfMonth([Дата]), type date),
    InsertEndOfMonth = Table.AddColumn(InsertStartOfMonth , "Конец месяца", each Date.EndOfMonth([Дата]), type date),
    InsertDay = Table.AddColumn(InsertEndOfMonth, "День месяца", each Date.Day([Дата])),
    InsertDayInt = Table.AddColumn(InsertDay, "Код даты", each [Год] * 10000 + [Номер месяца] * 100 + [День месяца]),
    InsertMonthName = Table.AddColumn(InsertDayInt, "Месяц", each Date.ToText([Дата], "MMMM", "RU"), type text),
    InsertShortMonthName = Table.AddColumn(InsertMonthName, "Мес.", each Date.ToText([Дата], "MMM", "RU"), type text),
    InsertCalendarMonth = Table.AddColumn(InsertShortMonthName, "Месяц года", each (try([#"Мес."]) otherwise [Месяц]) & " " & Number.ToText([Год])),
    InsertCalendarQtr = Table.AddColumn(InsertCalendarMonth, "Квартал года", each "Кв." & Number.ToText([Номер квартала]) & "-" & Number.ToText([Год])),
    InsertDayWeek = Table.AddColumn(InsertCalendarQtr, "Номер дня недели", each Date.DayOfWeek([Дата],Day.Monday)),
    InsertDayName = Table.AddColumn(InsertDayWeek, "День недели", each Date.ToText([Дата], "dddd", "RU"), type text),
    InsertShortDayName = Table.AddColumn(InsertDayName, "День", each Date.ToText([Дата], "ddd", "RU"), type text),
    InsertWeekEnding = Table.AddColumn(InsertShortDayName, "Конец недели", each Date.EndOfWeek([Дата]), type date),
    InsertWeekNumber= Table.AddColumn(InsertWeekEnding, "Номер недели", each Date.WeekOfYear([Дата])),
    InsertMonthnYear = Table.AddColumn(InsertWeekNumber,"Код месяца года", each [Год] * 10000 + [Номер месяца] * 100),
    InsertQuarternYear = Table.AddColumn(InsertMonthnYear,"Код квартала года", each [Год] * 10000 + [Номер квартала] * 100),
    ChangedType1 = Table.TransformColumnTypes(InsertQuarternYear,{{"Код квартала года", Int64.Type},{"Номер недели", Int64.Type},{"Квартал", type text},{"Год", type text},{"Код месяца года", Int64.Type}, {"Код даты", Int64.Type}, {"День месяца", Int64.Type}, {"Номер квартала", Int64.Type}, {"Месяц года", type text}, {"Квартал года", type text}, {"Номер дня недели", Int64.Type}})
  in
    ChangedType1
in
    fnDateTableRus
