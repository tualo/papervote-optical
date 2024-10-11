<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;

use Ramsey\Uuid\Uuid;

class Save implements IRoute
{



    public static function register()
    {
        BasicRoute::add('/papervote/opticaledit', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                $db->direct('update papervote_optical set is_final = 0, edited_marks = {marks}  where pagination_id={id} ', $_POST);
                App::result('success', true);
                $db->commit();
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);

        BasicRoute::add('/papervote/opticaledit/confirm', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                
                $db->direct('update papervote_optical set marks = edited_marks  where pagination_id={id} and  marks <> edited_marks', $_POST);
                $db->direct('update papervote_optical set is_final = 1  where pagination_id={id}', $_POST);

                App::result('success', true);
                $db->commit();

            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);


        BasicRoute::add('/papervote/opticaledit/pre_processed', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                
                $db->direct('update papervote_optical set  marks = edited_marks, pre_processed = 1  where pagination_id={id} and marks <> edited_marks and is_final = 0 ', $_POST);

                App::result('success', true);
                $db->commit();

            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);

        BasicRoute::add('/papervote/opticaledit/reject', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                $db->direct('update papervote_optical set edited_marks = "[]"  where pagination_id={id}', $_POST);
                App::result('success', true);
                $db->commit();
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);

        BasicRoute::add('/papervote/opticaldata', function ($matches) {

            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);

            $db->autoCommit(false);
            try {
                if (!isset($_POST['boxbarcode'])) {
                    throw new Exception('boxbarcode is missing');
                }
                if (!isset($_POST['stackbarcode'])) {
                    throw new Exception('stackbarcode is missing');
                }
                if (!isset($_POST['barcode'])) {
                    throw new Exception('barcode is missing');
                }
                if (!isset($_POST['id'])) {
                    throw new Exception('id is missing');
                }
                if (!isset($_POST['marks'])) {
                    throw new Exception('marks is missing');
                }
                
                if (!isset($_POST['image'])) {
                    throw new Exception('image is missing');
                }
                /*
                list($mime, $data) =  explode(',', $_POST['image']);
                $etag = md5($data);
                $size = (getimagesizefromstring(base64_decode($data)));
                */

                $sql = 'insert into papervote_optical (pagination_id, box_id, stack_id, ballotpaper_id, marks) 
                values ({barcode}, {boxbarcode}, {stackbarcode}, {id}, {marks})
                on duplicate key update marks={marks}, box_id={boxbarcode}, stack_id={stackbarcode}, ballotpaper_id={id}
                ';
                $db->direct($sql, [
                    'barcode' => $_POST['barcode'],
                    'boxbarcode' => $_POST['boxbarcode'],
                    'stackbarcode' => $_POST['stackbarcode'],
                    'id' => $_POST['id'],
                    'marks' => $_POST['marks']
                ]);

                $sql = 'replace into papervote_optical_data (pagination_id, data) values ({barcode}, {image})';
                $db->direct($sql, [
                    'barcode' => $_POST['barcode'],
                    'image' => $_POST['image']
                ]);
                App::result('success', true);
                $db->commit();
            } catch (Exception $e) {
                $db->rollback();
                
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);
    }
}
