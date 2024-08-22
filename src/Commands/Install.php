<?php
namespace Tualo\Office\PaperVoteOptical\Commands;

use Tualo\Office\Basic\CommandLineInstallSQL;
use Tualo\Office\Basic\ICommandline;

class Install extends CommandLineInstallSQL  implements ICommandline{
    public static function getDir():string {   return dirname(__DIR__,1); }
    public static $shortName  = 'papervote-optical';
    public static $files = [
        
        'stackcodes_setup'=> 'setup stackcodes_setup',
        'stackcodes_setup.ds'=> 'setup stackcodes_setup.ds',

        'boxcodes_setup'=> 'setup boxcodes_setup',
        'boxcodes_setup.ds'=> 'setup boxcodes_setup.ds',


        'pagination_setup'=> 'setup pagination_setup',
        'pagination_setup.ds'=> 'setup pagination_setup.ds',

        'labelbogen.pug'=> 'setup labelbogen.pug',
        
        'papervote_optical'=> 'setup papervote_optical',
        'papervote_optical.ds'=> 'setup papervote_optical.ds',

        'sz_rois'=> 'setup sz_rois',
        'view_readtable_sz_rois'=> 'setup view_readtable_sz_rois',
        
        'sz_rois.ds'=> 'setup sz_rois.ds',

        'sz_page_sizes'=> 'setup sz_page_sizes',
        'sz_page_sizes.ds'=> 'setup sz_page_sizes.ds',

        'sz_titel_regions'=> 'setup sz_titel_regions',
        'sz_titel_regions.ds'=> 'setup sz_titel_regions.ds',
        

        'stimmzettel_roi'=> 'setup stimmzettel_roi',
        'stimmzettel_roi.ds'=> 'setup stimmzettel_roi.ds',
        
        'sz_to_region'=> 'setup sz_to_region',
        'sz_to_region.ds'=> 'setup sz_to_region.ds',

        'sz_to_page_sizes'=> 'setup sz_to_page_sizes',
        'sz_to_page_sizes.ds'=> 'setup sz_to_page_sizes.ds',

        'view_sz_expected_marks'=> 'setup view_sz_expected_marks',
        'view_sz_expected_marks.ds'=> 'setup view_sz_expected_marks.ds',

        'view_sz_titles_by_page'=> 'setup view_sz_titles_by_page',
        'view_sz_titles_by_page.ds'=> 'setup view_sz_titles_by_page.ds',

        'view_papervote_optical_result'=> 'setup view_papervote_optical_result',
        'view_papervote_optical_result.ds'=> 'setup view_papervote_optical_result.ds',

        'view_sz_optical_config'=> 'setup view_sz_optical_config',
        'view_sz_optical_config.ds'=> 'setup view_sz_optical_config.ds',

    ];
    
}