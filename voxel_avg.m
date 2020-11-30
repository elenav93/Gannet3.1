% initialize useful directories
parent_dir = pwd;     % choose parent directory  

subject_dir ='Subject_folders'; %directory where all subject data are

on_dir ='mpress_on';
MPRAGE_one = 'T1w_one';
dcm_file_type = 'dcm'; 
nii_file_type = 'nii';
MRS_struct=struct;

%sift through each subject folder to get files
    for j=1:length(subject_dir)     
        
        %create formatted filenames for metabfile
        metabfile = {};
        for ii=1 

         MRS_struct.ii= ii; 

         metabfile {end + 1} = sprintf('mpresson%d.%s', ii, dcm_file_type);

        on_files = fullfile(subject_dir, on_dir);

        end 
    
         metabfile {1} = fullfile(on_files, metabfile {1});
    
        %create filename for T1w nii file 

        niifile = {};
        for ii = 1

        niifile {end + 1} = sprintf('MPR1.nii', ii, nii_file_type);

        end 

        niifile {1} = fullfile(parent_dir, MPRAGE_one, niifile {1}); 

        %run through coregister function to get mask data for each subject
        MRS_struct = CoRegStandAlone(metabfile, niifile);  
        
        %compile mask data (transverse, coronal, sagittal) from MRS_struct
        
        MRS_struct.img_t{j,:} = MRS_struct.img_t;
        MRS_struct.img_c{j,:} = MRS_struct.img_c;
        MRS_struct.img_s{j,:} = MRS_struct.img_s;
    end

    size_max = max([max(size(img_t)) max(size(img_c)) max(size(img_s))]);
    three_plane_img = zeros([size_max 3*size_max]);
    three_plane_img(:,1:size_max)              = image_center(img_t, size_max);
    three_plane_img(:,size_max+(1:size_max))   = image_center(img_s, size_max);
    three_plane_img(:,size_max*2+(1:size_max)) = image_center(img_c, size_max);

    MRS_struct.mask.(vox{kk}).img{ii} = three_plane_img;
    MRS_struct.mask.(vox{kk}).T1image(ii,:) = {nii_file};
    
    % Build output figure with all subjects dlpfc voxel normalized to standard MNI output
        if ishandle(103)
            clf(103); % MM (170720)
        end
        h = figure(103);
        % MM (170629): Open figure in center of screen
        scr_sz = get(0, 'ScreenSize');
        fig_w = 1000;
        fig_h = 707;
        set(h, 'Position', [(scr_sz(3)-fig_w)/2, (scr_sz(4)-fig_h)/2, fig_w, fig_h]);
        set(h,'Color',[1 1 1]);
        figTitle = 'GannetCoRegister AllSubjects';
        set(gcf,'Name',figTitle,'Tag',figTitle,'NumberTitle','off');

        subplot(2,3,4:6)
        axis off;

        h = subplot(2,3,1:3);
        t = 'All Subjects';

        imagesc(squeeze(MRS_struct.mask.(vox{kk}).img{ii}));
        colormap('gray');
        img = c;
        img = img(:);
        caxis([0 mean(img(img>0.01)) + 3*std(img(img>0.01))]); % MM (180807)
        axis equal;
        axis tight;
        axis off;
        text(10,size(MRS_struct.mask.(vox{kk}).img{ii},1)/2,'L','Color',[1 1 1],'FontSize',20);
        text(size(MRS_struct.mask.(vox{kk}).img{ii},2)-20,size(MRS_struct.mask.(vox{kk}).img{ii},1)/2,'R','Color',[1 1 1],'FontSize',20);
        get(h,'pos');
        set(h,'pos',[0.0 0.15 1 1]);
        title(t, 'FontName', 'Helvetica', 'FontSize', 15, 'Interpreter', 'none');

        % Gannet logo
        Gannet_path = which('GannetLoad');
        Gannet_logo = [Gannet_path(1:end-13) '/Gannet3_logo.png'];
        I = imread(Gannet_logo,'png','BackgroundColor',[1 1 1]);
        axes('Position',[0.80, 0.05, 0.15, 0.15]);
        imshow(I);
        text(0.9, 0, MRS_struct.version.Gannet, 'Units', 'normalized', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
        axis off;
        axis square;

        
        % Create output folder
        if ~exist(fullfile(pwd, 'CoRegStandAlone_output'),'dir')
            mkdir(fullfile(pwd, 'CoRegAllSubjects'));
        end

        % Save PDF output
        set(gcf,'PaperUnits','inches');
        set(gcf,'PaperSize',[11 8.5]);
        set(gcf,'PaperPosition',[0 0 11 8.5]);
        pdfname = fullfile(pwd, 'AllSubjectsCoReg', [metabfile_nopath '_' vox{kk} '_coreg.pdf']);
        saveas(gcf, pdfname);
        
   
    end
