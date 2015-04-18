function txt = myupdatefcn(empt,event_obj)
% Customizes text of data tips

pos = get(event_obj,'Position');
x = pos(1); y=pos(2);
[ dipdir, dip ] = f_cart2clar( x,y );
txt = {['Time: ',num2str(dipdir)], 'Amplitude: ',num2str(dip)]};
