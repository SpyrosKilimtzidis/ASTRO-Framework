function [data_ses]=write_bdfoutput(bdfname,grpid,data_ses)
jk=length(data_ses{1});
key1=sprintf('jobfile.open( "%s", "ANALYZE NO JOBFILE" )',bdfname);
key2=sprintf('msc_delete_old_files( "%s", ".bdf", ".op2" )',bdfname);
key3=sprintf('jobfile.writec( "JOBNAME", "%s" )',bdfname);
key4=sprintf('jobfile.writec( "GROUP", "%s" )',grpid);
key5='jobfile.writei( "SELECTED GROUP 0", 1 )';
key6=sprintf('jobfile.writec( "SELECTED GROUP 1", "%s" )',grpid);
key7=sprintf('mscnastran_job.associate_subcases( "101", "%s", 1, ["Default"] )',bdfname);
key8=sprintf('analysis_submit_2( "MSC.Nastran", "%s" )',bdfname);
%Write ses
fsesn='group2bdf.ses';
fid6s=fopen(fsesn);
data3=textscan(fid6s,'%s', 'delimiter', '\n');

for I=1:length(data3{1})
    if I==1
 data_ses{1}{jk+I}=key1;
    elseif I==2
 data_ses{1}{jk+I}=key2;
    elseif I==8
 data_ses{1}{jk+I}=key3;
   elseif I==19
 data_ses{1}{jk+I}=key4;
   elseif I==20
 data_ses{1}{jk+I}=key5;
     elseif I==21
 data_ses{1}{jk+I}=key6;
   elseif I==171
 data_ses{1}{jk+I}=key7;
   elseif I==172
 data_ses{1}{jk+I}=key8;
    else
 data_ses{1}{jk+I}=data3{1}{I};
    end
end
