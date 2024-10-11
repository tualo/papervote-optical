<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;
use Tualo\Office\DS\DataRenderer;
use Ramsey\Uuid\Uuid;

class Image implements IRoute
{



    public static function register()
    {
        BasicRoute::add('/papervote/opticalimagesvg/(?P<id>[\/.\w\d\-\_\.]+)', function ($matches) {
            try{
            $db = App::get('session')->getDB();
            
            $imagedata = $db->singleValue('select replace(data," ","+") data from papervote_optical_data where pagination_id={id}', ['id' => $matches['id']], 'data');
            if ($imagedata === false) {
                http_response_code(404);
                BasicRoute::$finished = true;
                exit();
            }
            list($mime, $data) =  explode(',', $imagedata);
            $size = (getimagesizefromstring(base64_decode($data)));
            
            $imagedata = './papervote/opticalimage/'.$matches['id'];

            $ballotpaper_id = $db->singleValue('select ballotpaper_id from papervote_optical where pagination_id={id}', ['id' => $matches['id']], 'ballotpaper_id');
// alter table kandidaten add bp_column integer default 0;
// alter table sz_rois add item_height integer default 20;
// alter table sz_rois add item_cap_y decimal(15,5) default 0.5;

            $result = $db->direct('select view_papervote_optical_result_ballotpaper.*,
rank() over (
    partition by pagination_id,
    sz_rois_id
    order by result_index
) roi_pos from view_papervote_optical_result_ballotpaper where pagination_id={id}', ['id' => $matches['id']]);

            $sql ='select 
                view_readtable_kandidaten_bp_column.result_index,
                sz_rois.id roi_id,
                sz_rois.name roi_name,
                sz_rois.x   roi_x,
                sz_rois.y   roi_y,
                sz_rois.width roi_width,
                sz_rois.height roi_height,

                
                sz_rois.item_height roi_item_height,
                sz_rois.item_cap_y roi_item_cap_y,

                sz_page_sizes.width page_width,
                sz_page_sizes.height page_height
            from 
                (select 
                kandidaten_bp_column.kandidaten_id,
                stimmzettel.id stimmzettel_id,
                kandidaten_bp_column.stimmzettelgruppen_id,
                kandidaten_bp_column.sz_rois_id,
                kandidaten_bp_column.kandidaten_id_checked,
                kandidaten_bp_column.position,
                kandidaten.nachname anzeige_name,
                sz_rois.x,
                sz_rois.y,
                rank() over (
                    partition by 
                        stimmzettel.id
                    order by 
                        sz_rois.x,
                        sz_rois.y,
                        kandidaten_bp_column.position
                ) result_index
            from 
                kandidaten_bp_column
                join sz_rois
                    on sz_rois.id = kandidaten_bp_column.sz_rois_id
                join stimmzettelgruppen
                    on stimmzettelgruppen.id = kandidaten_bp_column.stimmzettelgruppen_id
                join stimmzettel
                    on stimmzettelgruppen.stimmzettel = stimmzettel.ridx
                join kandidaten
                    on kandidaten.id = kandidaten_bp_column.kandidaten_id
            where 
                kandidaten_id_checked=1) as  view_readtable_kandidaten_bp_column
                join stimmzettel 
                    on view_readtable_kandidaten_bp_column.stimmzettel_id = stimmzettel.id
                join stimmzettel_roi 
                    on stimmzettel_roi.stimmzettel_id = stimmzettel.id
                join sz_rois 
                    on stimmzettel_roi.sz_rois_id = sz_rois.id
                join sz_to_region 
                    on sz_to_region.id_sz = stimmzettel.id
                join sz_titel_regions 
                    on  sz_titel_regions.id = sz_to_region.id_sz_titel_regions
                join sz_to_page_sizes 
                    on sz_to_page_sizes.id_sz = stimmzettel.id
                join sz_page_sizes 
                    on  sz_to_page_sizes.id_sz_page_sizes = sz_page_sizes.id
            where 
                stimmzettel.id={ballotpaper_id}';
            $data = $db->direct($sql, ['ballotpaper_id'=>$ballotpaper_id]);

            /*
            echo $db->last_sql;
            exit();
            */

            $roisRegionSVG = [];
            $fields = [];
            $index =0;
            foreach($data as $row){
                $scale_x = $size[0]/$row['page_width'];
                $scale_y = $size[1]/$row['page_height'];
                $roi_x = ($row['roi_x']*$scale_x);
                $roi_y = ($row['roi_y']*$scale_y);
                $cap = $row['roi_item_cap_y'];

                
                // <text x="'.$roi_x.'" y="'.($roi_y + ($row['roi_height']*$scale_y) ).'" font-size="20">'.$row['roi_name'].' '.$row['roi_id'].'</text>
                    
                $roisRegionSVG[] = '<g class="hover_group" opacity="0.1">
                    <rect x="'.$roi_x.'" y="'.$roi_y.'" opacity="0.2" fill="#0000FF" width="'.($row['roi_width']*$scale_x).'" height="'.($row['roi_height']*$scale_y).'"></rect>
                </g>';

                foreach($result as $result_row){
                    if( $result_row['sz_rois_id']!=$row['roi_id']) continue;

                    $color = '#FF0000';
                    if ($result_row['marked'] == 'X') $color = '#00FF00';
                    $offset = ($result_row['roi_pos'] -1 )*$row['roi_item_height'] + ($result_row['roi_pos'] -1 )* $cap ;
//                    $fields[] = '<g class="hover_group"  opacity="0.6">
                    $fields[] = '<g class="hover_group"   >
                    <a href="#papervote-optical/oversightclick/svg/'.($result_row['result_index'] -1 ).'" data-attr="'.$result_row['anzeige_name'].'" title="Hallo">

                        <rect x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y .'" opacity="0.5" fill="transparent" width="'.($row['roi_width']*$scale_x).'" height="'.($row['roi_item_height']*$scale_y - $cap*$scale_y).'"></rect>
                        <circle 
                            cx="'.$roi_x + ($row['roi_width']*$scale_x) / 2 .'" cy="'.$roi_y + $offset*$scale_y + ($row['roi_item_height']*$scale_y - $cap*$scale_y) / 2 .'" r="'. (($row['roi_item_height']-$cap*2)*$scale_x) / 2 .'" 
                        stroke-width="5" stroke="'.$color.'"
                        fill="none"
                        ></circle>
                    </a>
                    </g>';
                    $index++;
                }
            }

            //  <text x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y+ 30 .'" font-size="20">'.$result_row['anzeige_name'].' '. $result_row['result_index'].'</text>
            //  
                        
            



            App::contenttype('image/svg+xml');
            $svg = file_get_contents(__DIR__.'/svg_template.svg');
            App::body(
                DataRenderer::renderTemplate($svg, [
                    'rois_svg' => implode("\n",$roisRegionSVG),
                    'fields' => implode("\n",$fields),
                    'imageurl' => $imagedata,
                    'width' => $size[0],
                    'height' => $size[1]
                ])
            );
            BasicRoute::$finished = true;
            http_response_code(200);
        }catch(Exception $e){
            echo $e->getMessage();
            http_response_code(500);
            BasicRoute::$finished = true;
            exit();
        }
        }, ['get'], true);

        BasicRoute::add('/papervote/opticalimage/(?P<id>[\/.\w\d\-\_\.]+)', function ($matches) {

            App::contenttype('application/json');

            $db = App::get('session')->getDB();
            $imagedata = $db->singleValue('select replace(data," ","+") data from papervote_optical_data where pagination_id={id}', ['id' => $matches['id']], 'data');
            if ($imagedata === false) {
                http_response_code(404);
                BasicRoute::$finished = true;
                exit();
            }
            
            BasicRoute::$finished = true;
            http_response_code(200);

            list($mime, $data) =  explode(',', $imagedata);
            $etag = md5($data);
            App::contenttype(str_replace('data:', '', $mime));

            header("Etag: $etag");
            header('Cache-Control: public');

            if (
                (isset($_SERVER['HTTP_IF_NONE_MATCH']) && (trim($_SERVER['HTTP_IF_NONE_MATCH']) == $etag))
            ) {
                header("HTTP/1.1 304 Not Modified");
                exit;
            }

            App::body(base64_decode($data));
            BasicRoute::$finished = true;
            http_response_code(200);
        
        },['get'],true);
    }
}
