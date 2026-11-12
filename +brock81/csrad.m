function it = csrad (lat, doy, hour)
rad = pi/180; solar=1.353e3; fd=rad*360/365;
ac0=0.12814; ab0=0.7568875; k0=0.387225;
[d1, cosz] = brock81.angles(lat, doy, hour);
ir1s = 1 + 0.033.*cos(fd.*doy);              % 1/r1², r1 is the radius vector
sr = solar.*ir1s.*cosz;                        % rad. at top of atmosphere
fak = cos(rad.*lat).*(1 - sign(rad.*lat).*d1);
ac = ac0.*(0.95 + 0.05.*fak);
ab = ab0.*(0.98 + 0.02.*fak);
k = k0.*(1.02 - 0.02.*fak);
tr = ac + ab.*exp(-min(k./cosz, 700));
td = 0.2710 - 0.2939.*tr;
it = sr.*(tr + td);
