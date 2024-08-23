<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;
use Tualo\Office\DS\DataRenderer;
use Ramsey\Uuid\Uuid;
use Tualo\Office\DS\DSTable;
use Tualo\Office\DS\DSFiles;


class SetupImage implements IRoute
{

    public static function subPath($taskID,$fn){
        $tempdir = App::get('tempPath');
        return implode('/',[$tempdir,$taskID,$fn]);
    }

    public static function getPage($id)
    {
        

            $pdfPages=[];
            $jpegPages=[];
            $taskID = 123;

            if (!file_exists( self::subPath($taskID,$id) )) mkdir( self::subPath($taskID,$id) ,0777,true );
    
            $params = [];
            $params[] = '-q';
            $params[] = '-dNOPAUSE';
            // $params[] = '-dDOPDFMARKS=false';
            $params[] = '-dBATCH';
            $params[] = '-sDEVICE=pngalpha';
            $params[] = '-r144';
            $params[] = '-sOutputFile="'.implode('/',[self::subPath($taskID,$id),'%05d.png']).'"';
            // $params[] = '-dPDFFitPage';
            //$params[] = '-dFIXEDMEDIA';
            //$params[] = '-sPAPERSIZE=a4';
            // $params[] = '-dAutoRotatePages=/None';
            $params[] = '"'.implode('/',[self::subPath($taskID,$id.'.pdf')]).'"';
            
            exec('gs '.implode(' ',$params),$pdfwrite,$res_code);

            $glob_result = glob(implode('/',[self::subPath($taskID,$id),'*.png']));
            foreach($glob_result as $file){
                $pdfPages[]=$file;
            }
            if (count($pdfPages)!=1){
                throw new Exception('Page count is wrong');
            }
            return $pdfPages[0];
            /*
            $params = [];
            $params[] = '-q';
            $params[] = '-dNOPAUSE';
            $params[] = '-dDOPDFMARKS=false';
            $params[] = '-dBATCH';
            $params[] = '-sDEVICE=jpeg';
            $params[] = '-r300';
            $params[] = '-sOutputFile="'.implode('/',[self::subPath($taskID,$item['id']),'%05d.jpg']).'"';
            $params[] = '"'.$item['pdfname'].'"';
    
            exec('gs '.implode(' ',$params),$jpeg);
    
            $glob_result = glob(implode('/',[self::subPath($taskID,$item['id']),'*.jpg']));
            foreach($glob_result as $file){
                $jpegPages[]=$file;
            }
    
            return [
                'cmd'=>'gs '.implode(' ',$params),
                'subPath'=>self::subPath($taskID,$item['id']),
                'pdf' => $pdfPages,
                'images' => $jpegPages
            ];
        }
            */
    }


    public static function register()
    {
        BasicRoute::add('/papervoteoptical/image/(?P<id>[\/.\w\d\-\_\.]+)', function ($matches) {

            $db = App::get('session')->getDB();
            try{


            $data = DSTable::instance('stimmzettel_pdfs')->f('stimmzettel_id','eq',$matches['id'])->read()->getSingle();
            $pdfdata = DSFiles::instance('stimmzettel_pdfs')->getBase64('id',$data['id']);
            // echo App::get('tempPath').'/'.$data['file_id'].'.pdf';
            list($mime,$rawdata) =  explode(',',$pdfdata);
            file_put_contents(App::get('tempPath').'/123/'.$data['file_id'].'.pdf' ,base64_decode($rawdata));

            

            $filename = self::getPage($data['file_id']);
            $size = getimagesize($filename);

  //          print_r($size);


            $imagedata = 'data:image/png;base64,'.base64_encode(file_get_contents($filename));

/*
            echo "Breite: ".($size[0]/144*2.54)."cm\n";
            echo "Höhe: ".($size[1]/144*2.54)."cm\n";
            exit();
*/

            $svg = file_get_contents(__DIR__.'/svg_setup_template.svg');
            App::body(
                DataRenderer::renderTemplate($svg, [
                    //'rois_svg' => implode("\n",$roisRegionSVG),
                    //'fields' => implode("\n",$fields),
                    'imageurl' => $imagedata,
                    'width' => $size[0],
                    'height' => $size[1]
                ])
            );

            /*
            $p = new Pdf(App::get('tempPath').'/'.$data['file_id'].'.pdf');
            $numberOfPages = $p->pageCount();
            exit();
            exit();
            */
//var_dump($p);





            /*
            $imagedata = $db->singleValue('select replace(data," ","+") data from `stimmzettel_pdfs`
                left join `ds_files` on(
                    `stimmzettel_pdfs`.`file_id` = `ds_files`.`file_id`
        ) where pagination_id={id}', ['id' => $matches['id']], 'data');
            if ($imagedata === false) {
                http_response_code(404);
                BasicRoute::$finished = true;
                exit();
            }
            list($mime, $pdfdata) =  explode(',', $imagedata);
            $size = (getimagesizefromstring(base64_decode($data)));

            
    ->save($pathToWhereImageShouldBeStored); //saves the second page

     // resolution of 300 dpi
    ->save($pathToWhereImageShouldBeStored);
        


        App::contenttype('image/svg+xml');

            $sql ='select 
                RANK() OVER (
                    PARTITION BY stimmzettel.id
                    ORDER BY sz_rois.x
                ) bp_column,
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
            $data = $db->direct($sql, $matches);

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
            */

            //    echo 123; exit();
            BasicRoute::$finished = true;
            http_response_code(200);
        }catch(Exception $e){
            echo $e->getMessage();
            http_response_code(500);
            BasicRoute::$finished = true;
            exit();
        }
        }, ['get'], true);
    }
}