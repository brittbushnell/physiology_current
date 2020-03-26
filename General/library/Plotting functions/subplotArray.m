function varargout = subplotArray(map,elec)

Iplot = max(map.row);
Jplot = max(map.col);
subplot2(Iplot,Jplot,map.row(elec),map.col(elec))
