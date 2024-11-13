<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;

use Ramsey\Uuid\Uuid;

class Config implements IRoute
{



    public static function register()
    {

        BasicRoute::add('/papervote/roi/config', function ($matches) {
            App::contenttype('application/json');

            $db = App::get('session')->getDB();
            $result = [];
            $result = $db->direct('select * from view_papervote_roi_config');
            BasicRoute::$finished = true;
            App::result('success', true);
            App::result('data', $result);
            
        }, ['get'], true);
        

        BasicRoute::add('/papervote/opticaldata/config', function ($matches) {

            App::contenttype('application/json');

            $db = App::get('session')->getDB();
            $result = [];
            $liste = $db->direct('select o from view_sz_optical_config');
            foreach ($liste as $item) {
                $item = json_decode($item['o'], true);
                $ts = [];
                foreach ($item['titles'] as $field) {
                    $ts[] = $field['titel'];
                }
                $item['titles'] = $ts;
                $result[] = $item;
            }

            //$data = file_get_contents(__DIR__.'/sample.json');
            echo json_encode($result);
            BasicRoute::$finished = true;
            http_response_code(200);
            exit();
        }, ['get'], true);
    }
}
