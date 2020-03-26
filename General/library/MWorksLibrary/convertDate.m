function  [goodDate] = convertDate(date)


year = str2num(date(1:4));
month = str2num(date(5:6));
day = str2num(date(7:8));

year = num2str(year);
month = num2str(month);
day = num2str(day);

goodDate = [month,'/',day,'/',year];
