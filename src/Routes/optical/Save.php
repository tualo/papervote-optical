<?php

namespace Tualo\Office\PaperVoteOptical\Routes\optical;

use Exception;
use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\TualoPGP\TualoApplicationPGP;

use Ramsey\Uuid\Uuid;

class Save extends \Tualo\Office\Basic\RouteWrapper
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

                $db->direct('call proc_papervote_optical_ai_mat_table({id}) ', $_POST);
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
                if (
                    $db->singleValue('select count(*) v from ds_access  join view_session_allowed_groups on view_session_allowed_groups.group = ds_access.role and ds_access.write = 1 and  table_name = "papervote_optical"', [], 'v') === 0
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }

                $db->direct('update papervote_optical set marks = edited_marks  where pagination_id={id} and  marks <> edited_marks and json_value(`papervote_optical`.edited_marks,"$[0]")!="W"', $_POST);
                $db->direct('update papervote_optical set is_final = 1  where pagination_id={id}', $_POST);

                App::result('success', true);
                $db->commit();

                /*
                $db->direct('call proc_papervote_optical_ai_mat_table({id}) ', $_POST);
                $db->commit();
                */
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);

        BasicRoute::add('/papervote/opticaledit/permissions', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {
                $data = [
                    'confirm' => false,
                    'reject' => false,
                    'pre_processed' => false,
                    'is_ok' => false
                ];

                if (
                    $db->singleValue('select `group` v from view_session_allowed_groups where `group` in ("administration")', [], 'v') !== false
                ) {
                    $data['pre_processed'] = true;
                    $data['is_ok'] = true;
                }
                if (
                    $db->singleValue('select count(*) v from ds_access  join view_session_allowed_groups on view_session_allowed_groups.group = ds_access.role and ds_access.write = 1 and  table_name = "papervote_optical"', [], 'v') != 0
                ) {
                    $data['confirm'] = true;
                    $data['reject'] = true;
                }

                App::result('success', true);
                App::result('data', $data);
                $db->commit();
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['get'], true);

        BasicRoute::add('/papervote/opticaledit/pre_processed', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {

                if (
                    $db->singleValue('select `group` v from view_session_allowed_groups where `group` in ("administration")', [], 'v') === false
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }
                if (
                    $db->singleValue('select count(*) v from ds_access  join view_session_allowed_groups on view_session_allowed_groups.group = ds_access.role and ds_access.write = 1 and  table_name = "papervote_optical"', [], 'v') === 0
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }
                $db->direct('update papervote_optical set  marks = edited_marks, pre_processed = 1  where pagination_id={id} and marks <> edited_marks and is_final = 0 ', $_POST);

                App::result('success', true);
                $db->commit();

                /*
                $db->direct('call proc_papervote_optical_ai_mat_table({id}) ', $_POST);
                $db->commit();
                */
            } catch (Exception $e) {
                $db->rollback();
                App::result('msg', $e->getMessage());
            }
        }, ['post'], true);




        BasicRoute::add('/papervote/opticaledit/is_ok', function ($matches) {
            App::contenttype('application/json');
            $db = App::get('session')->getDB();
            App::result('success', false);
            $db->autoCommit(false);
            try {

                if (
                    $db->singleValue('select `group` v from view_session_allowed_groups where `group` in ("administration")', [], 'v') === false
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }
                if (
                    $db->singleValue('select count(*) v from ds_access  join view_session_allowed_groups on view_session_allowed_groups.group = ds_access.role and ds_access.write = 1 and  table_name = "papervote_optical"', [], 'v') === 0
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }
                $db->direct('update papervote_optical set is_visible_ok = 1  where pagination_id={id} and is_final = 0 ', $_POST);

                App::result('success', true);
                $db->commit();

                /*
                $db->direct('call proc_papervote_optical_ai_mat_table({id}) ', $_POST);
                $db->commit();
                */
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
                if (
                    $db->singleValue('select count(*) v from ds_access  join view_session_allowed_groups on view_session_allowed_groups.group = ds_access.role and ds_access.write = 1 and  table_name = "papervote_optical"', [], 'v') === 0
                ) {
                    throw new Exception("Dies ist nicht erlaubt");
                }

                $db->direct('update papervote_optical set edited_marks = "[]"  where pagination_id={id}', $_POST);
                App::result('success', true);
                $db->commit();

                /*
                $db->direct('call proc_papervote_optical_ai_mat_table({id}) ', $_POST);
                $db->commit();
                */
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

                $sql = 'insert into papervote_optical (
                    pagination_id, 
                    box_id, 
                    stack_id, 
                    ballotpaper_id, 
                    marks
 
                ) 
                values (
                    {barcode},
                    {boxbarcode}, 
                    {stackbarcode},
                    {id}, 
                    {marks}
 
                )
                on duplicate key update 
                    marks={marks}, 
                    box_id={boxbarcode}, 
                    stack_id={stackbarcode},
                    ballotpaper_id={id},

                    edited_marks="[]",
                    is_final=0,
                    pre_processed=0
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
