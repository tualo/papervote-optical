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
            $etag = md5($data);
            
            $imagedata = './papervote/opticalimage/'.$matches['id'];

            $ballotpaper_id = $db->singleValue('select ballotpaper_id from papervote_optical where pagination_id={id}', ['id' => $matches['id']], 'ballotpaper_id');

            $result = $db->direct('
            select 
                view_papervote_optical_result_ballotpaper.*,
                rank() over (
                    partition by pagination_id,
                    sz_rois_id
                    order by result_index
                ) roi_pos 
            from 
                view_papervote_optical_result_ballotpaper 
            where pagination_id={id}', ['id' => $matches['id']]);

            $sql ='select 
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
                stimmzettel 
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

            $testdata = $db->direct('
            with bv as (
                select pagination_id,pos,analyse_type,val from pagination_test_result where analyse_type="bildverarbeitung"
            ), tf as (
                select pagination_id,pos,analyse_type,val from pagination_test_result where analyse_type="tensorflow 32x32x150"
            ), wz as (
                select pagination_id,result_index - 1 pos,"zählung" analyse_type, if(marked="O",0,if(marked="W",0.5,1)) val from view_papervote_optical_result_ballotpaper
            )
            select 
                bv.pagination_id,
                bv.pos + 1 pos,
                bv.val bv,
                tf.val tf,
                wz.val wz
            from 
                bv
                join tf on (bv.pagination_id,bv.pos) = (tf.pagination_id,tf.pos)
                join wz on (bv.pagination_id,bv.pos) = (wz.pagination_id,wz.pos)
            where bv.pagination_id={id}', ['id' => $matches['id']],'pos');

            $roisRegionSVG = [];
            $fields = [];
            $index =0;




            foreach($data as $row){
                $scale_x = $size[0]/$row['page_width'];
                $scale_y = $size[1]/$row['page_height'];
                $roi_x = ($row['roi_x']*$scale_x);
                $roi_y = ($row['roi_y']*$scale_y);
                $cap = $row['roi_item_cap_y'];

            foreach($result as $result_row){
                if( $result_row['sz_rois_id']!=$row['roi_id']) continue;

                $stroke_width=5;
                $color = '#FF0000';


                $offset = ($result_row['roi_pos'] -1 )*$row['roi_item_height'] + ($result_row['roi_pos'] -1 )* $cap ;

                $str_testdata = '';
                if (isset($testdata[$result_row['result_index']])){
                    $str_testdata = '
                    <text x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y  + ($row['roi_item_height']*$scale_y) /1.1 .'" font-size="50">'.$testdata[$result_row['result_index']]['tf'] .'</text>';
                    $str_testdata .= '
                    <text x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y + ($row['roi_item_height']*$scale_y) /2 .'" font-size="20">'.$testdata[$result_row['result_index']]['bv'].' '.$testdata[$result_row['result_index']]['tf'].' '.$testdata[$result_row['result_index']]['wz'].'</text>';

                }
                $fields[] = '<g class="hover_groupx"   >
                
                    '.$str_testdata.'
                </g>';
                $index++;
            }
        }            $index =0;


            foreach($data as $row){
                $scale_x = $size[0]/$row['page_width'];
                $scale_y = $size[1]/$row['page_height'];
                $roi_x = ($row['roi_x']*$scale_x);
                $roi_y = ($row['roi_y']*$scale_y);
                $cap = $row['roi_item_cap_y'];

                
                // <text x="'.$roi_x.'" y="'.($roi_y + ($row['roi_height']*$scale_y) ).'" font-size="20">'.$row['roi_name'].' '.$row['roi_id'].'</text>
                  
                /*
                $roisRegionSVG[] = '<g class="hover_group" opacity="0.1">
                    <rect x="'.$roi_x.'" y="'.$roi_y.'" opacity="0.2" fill="#0000FF" width="'.($row['roi_width']*$scale_x).'" height="'.($row['roi_height']*$scale_y).'"></rect>
                </g>';
                */




                foreach($result as $result_row){
                    if( $result_row['sz_rois_id']!=$row['roi_id']) continue;

                    $stroke_width=5;
                    $color = '#FF0000';

                    if ($result_row['marked'] == 'X') $color = '#00FF00';
                    if ( ($result_row['marked']=='') && ($result_row['edited_marked']=='W' ) ){
                         $color = '#0000FF';
                         $stroke_width=10;
                    }else{
                        if ($result_row['edited_marked'] != 'W'){
                        if ($result_row['edited_marked'] != $result_row['marked']) {
                                $stroke_width=10;
                                if ($result_row['edited_marked'] == 'X') $color = '#CCFF00';
                                if ($result_row['edited_marked'] == 'O') $color = '#FFFFFF';
                            }                    
                        }
                    }

                    $offset = ($result_row['roi_pos'] -1 )*$row['roi_item_height'] + ($result_row['roi_pos'] -1 )* $cap ;

                    $str_testdata = '';
                    /*
                    if (isset($testdata[$result_row['result_index']])){
                        $str_testdata = '
                        <text x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y + ($row['roi_item_height']*$scale_y) /2 .'" font-size="20">'.$testdata[$result_row['result_index']]['bv'].' '.$testdata[$result_row['result_index']]['tf'].' '.$testdata[$result_row['result_index']]['wz'].'</text>';

                    }
                    */
                    $fields[] = '<g class="hover_group"   >
                    <a href="#papervote-optical/oversightclick/svg/'.($result_row['result_index'] -1 ).'" data-attr="'.$result_row['anzeige_name'].'" title="Hallo">

                        <rect x="'.$roi_x.'" y="'.$roi_y + $offset*$scale_y .'" opacity="0.5" stroke="#000" fill="transparent" width="'.($row['roi_width']*$scale_x).'" height="'.($row['roi_item_height']*$scale_y - $cap*$scale_y).'"></rect>
                        <circle 
                            cx="'.$roi_x + ($row['roi_width']*$scale_x) / 2 .'" cy="'.$roi_y + $offset*$scale_y + ($row['roi_item_height']*$scale_y - $cap*$scale_y) / 2 .'" r="'. (($row['roi_item_height']-$cap*2)*$scale_x) / 2 /2 .'" 
                        stroke-width="'.$stroke_width.'" stroke="'.$color.'"
                        fill="none"
                        ></circle>
                        '.$str_testdata.'
                    </a>
                    </g>';
                    $index++;
                }
            }
                        
            

        


            App::contenttype('image/svg+xml');
            $svg = file_get_contents(__DIR__.'/svg_template.svg');
            App::body(
                DataRenderer::renderTemplate($svg, [
                    'rois_svg' => implode("\n",$roisRegionSVG),
                    'fields' => implode("\n",$fields),
                    'imageurl' => $imagedata.'?tag='.$etag,
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
