<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;

use Ramsey\Uuid\Uuid;

class DetectedCodes implements IRoute
{



    public static function register()
    {
        
        BasicRoute::add('/papervoteoptical/(?P<box>[\/.\w\d\-\_\.]+)/(?P<stack>[\/.\w\d\-\_\.]+)/(?P<pagination>[\/.\w\d\-\_\.]+)', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                $db->direct('insert ignore into detected_codes (box_code,stack_code,pagination_code,login) values ({box},{stack},{pagination},getSessionUser()) ', $matches);
                App::result('success', true);
                $db->commit();
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['get'], true);
        
    }
}
