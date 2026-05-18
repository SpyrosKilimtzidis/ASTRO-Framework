function [data_ses]=write_bdfoutput_total(data_ses)
jk=length(data_ses{1});
%Write ses
fsesn='model2bdf.ses';
fid6s=fopen(fsesn);
data3=textscan(fid6s,'%s', 'delimiter', '\n');
for I=1:length(data3{1})
 data_ses{1}{jk+I}=data3{1}{I};
end
