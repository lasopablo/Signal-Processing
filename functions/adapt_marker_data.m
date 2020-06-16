function out=adapt_marker_data(Markers)

for k=1:length(Markers.Labels)
    
    mark_lab= Markers.Labels{k}; % 
    eval(['out.' mark_lab '=Markers.RawData(:,3*k-2:3*k)']) % automatically define variables
end 