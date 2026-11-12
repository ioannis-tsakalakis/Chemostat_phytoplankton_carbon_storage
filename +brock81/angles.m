function [d1, cosz, w1] = angles (lat, doy, hour)
rad = pi/180; tilt=rad*23.45; fd=rad*360/365;
d15 = rad.*15;
d1 = tilt.*sin(fd.*(284 + doy));      % declination
w2 = d15.*(hour - 12);                % hour-angle
cosz = max(sin(d1).*sin(lat.*rad) + cos(d1).*cos(lat.*rad).*cos(w2), 0); %z=zenith angle
if nargout > 2
  cw1 = -tan(lat.*rad).*tan(d1);           % COS(sunset hour-angle)
  w1 = acos(sign(cw1).*(min(abs(cw1(cw1 < 0)), 1)));
end
