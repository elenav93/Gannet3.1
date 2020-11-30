% initialize useful directories
parent_dir = pwd;     % choose parent directory
                               
on_dir ='mpress_on';
    
    % create formatted filenames
    metabfile = {};
    for ii=1 
        
     MRS_struct.ii= ii; 
          
     metabfile {end + 1} = sprintf('mpresson%d.%s', ii, dcm_file_type);
            
    on_files=fullfile(parent_dir, on_dir);
  
    end 
    
     metabfile {1} = fullfile(on_files, metabfile {1});
           
      % concatenate directories and filenames to create complete filenames
         % example of using fullfile
             %fullfile(toolboxdir('matlab'),'iofun',{'filesep.m';'fullfile.m'})
 
     
   
%creat filename for T1w nii file 

niifile = {};
for ii = 1
      
niifile {end + 1} = sprintf('MPR1.nii', ii, nii_file_type);
 
end 

niifile {1} = fullfile(parent_dir, MPRAGE_one, niifile {1}); 

MRS_struct = CoRegStandAlone(metabfile, niifile);  
