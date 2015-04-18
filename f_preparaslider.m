function [slidervalue]=f_preparaslider(nppalpoles)
if nppalpoles == 0
    set(handles.slider_ppalpole,'Enable','off');
    set(handles.uitable_ppalpoles,'Enable','off');
    slidervalue=0;
end
if ppalpoles == 1
    slidervalue=1;
    set(handles.slider_ppalpole,'Value',slidervalue);
    set(handles.uitable_ppalpoles,'Enable','off');
end
if ppalpoles > 1
    set(handles.slider_ppalpole,'Enable','on','Min',1,'Max',nppalpoles,'Value',1,'SliderStep',[1 1]/nppalpoles);
    slidervalue=1;
end
end
