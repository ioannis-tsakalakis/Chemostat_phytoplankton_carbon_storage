function [Idaymean, Imean, DayDur] = av_light(lat, doy)
doy = floor(doy);
hours=0:0.01:24;
Iday = brock81.csrad(lat,(doy),hours);
%DayDur = brock81.daydur(lat, doy, 12);
From = find(Iday > 0, 1, 'first');
To   = find(Iday > 0, 1, 'last');
if isempty(From)
    DayDur =0;
else
   DayDur = hours(To) - hours(From);
end
Itot = trapz(hours, Iday);
Idaymean = Itot/24;          %%mean over 24 hours
Imean    = Itot/ DayDur;    %%mean over the light period