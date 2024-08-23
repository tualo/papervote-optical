<?php
namespace Tualo\Office\PaperVoteOptical\Commands;

use Tualo\Office\Basic\CommandLineInstallSQL;
use Tualo\Office\Basic\ICommandline;

class Install extends CommandLineInstallSQL  implements ICommandline{
    public static function getDir():string {   return dirname(__DIR__,1); }
    public static $shortName  = 'papervote-optical';
    public static $files = [
        
        'install/ds_class'=> 'setup ds_class',

        'install/stackcodes_setup'=> 'setup stackcodes_setup',
        'install/stackcodes_setup.ds'=> 'setup stackcodes_setup.ds',

        'install/boxcodes_setup'=> 'setup boxcodes_setup',
        'install/boxcodes_setup.ds'=> 'setup boxcodes_setup.ds',


        'install/pagination_setup'=> 'setup pagination_setup',
        'install/pagination_setup.ds'=> 'setup pagination_setup.ds',

        'install/labelbogen.pug'=> 'setup labelbogen.pug',
        
        'install/papervote_optical'=> 'setup papervote_optical',
        'install/papervote_optical.ds'=> 'setup papervote_optical.ds',

        'install/sz_rois'=> 'setup sz_rois',
        'install/view_readtable_sz_rois'=> 'setup view_readtable_sz_rois',

        'install/sz_rois.ds'=> 'setup sz_rois.ds',

        'install/sz_page_sizes'=> 'setup sz_page_sizes',
        'install/sz_page_sizes.ds'=> 'setup sz_page_sizes.ds',

        'install/sz_titel_regions'=> 'setup sz_titel_regions',
        'install/sz_titel_regions.ds'=> 'setup sz_titel_regions.ds',
        

        'install/stimmzettel_roi'=> 'setup stimmzettel_roi',
        'install/stimmzettel_roi.ds'=> 'setup stimmzettel_roi.ds',
        
        'install/sz_to_region'=> 'setup sz_to_region',
        'install/sz_to_region.ds'=> 'setup sz_to_region.ds',

        'install/sz_to_page_sizes'=> 'setup sz_to_page_sizes',
        'install/sz_to_page_sizes.ds'=> 'setup sz_to_page_sizes.ds',

        'install/view_sz_expected_marks'=> 'setup view_sz_expected_marks',
        'install/view_sz_expected_marks.ds'=> 'setup view_sz_expected_marks.ds',

        'install/view_sz_titles_by_page'=> 'setup view_sz_titles_by_page',
        'install/view_sz_titles_by_page.ds'=> 'setup view_sz_titles_by_page.ds',

        'install/view_papervote_optical_result'=> 'setup view_papervote_optical_result',
        'install/view_papervote_optical_result.ds'=> 'setup view_papervote_optical_result.ds',

        'install/view_sz_optical_config'=> 'setup view_sz_optical_config',
        'install/view_sz_optical_config.ds'=> 'setup view_sz_optical_config.ds',

        'install/stimmzettel_pdfs'=> 'setup stimmzettel_pdfs',
        'install/stimmzettel_pdfs.ds'=> 'setup stimmzettel_pdfs.ds',

        'install/kandidaten_bp_column'=> 'setup kandidaten_bp_column',
        'install/kandidaten_bp_column.ds'=> 'setup kandidaten_bp_column.ds',

        'install/kandidaten_bp_column_au_itemheight'=> 'setup kandidaten_bp_column_au_itemheight',
        

    ];
    
}