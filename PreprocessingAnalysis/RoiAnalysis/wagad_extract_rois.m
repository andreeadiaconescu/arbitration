function wagad_extract_rois(iSubjectArrayfMRI)

if nargin < 1
    iSubjectArrayfMRI =  setdiff([3:47], [6 14 25 31 32 33 34 37]);
end

maskArray = {[1 1],[2 2],[3 3],[4 4],[5 5],[6 6]};
groupMaskArray = {[1],[2],[3],[4],[5],[6]};

for iMask = 1:numel(maskArray)
    wagad_extract_roi_timeseries_by_arbitration(iSubjectArrayfMRI,maskArray{iMask});
end


for iGroupMask = 1:numel(groupMaskArray)
    wagad_compute_group_roi_CombinedTimeseries(iSubjectArrayfMRI,groupMaskArray{iGroupMask});
end

end