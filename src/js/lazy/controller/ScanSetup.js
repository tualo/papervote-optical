Ext.define('Tualo.PaperVote.Optical.lazy.controller.ScanSetup', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.papervote_optical_scan_setup',

    onSvgClick: function (id) {
        console.log('svg click',id);
        var me = this;
            sels = me.getView().down('#docs').getSelection();
        if (sels.length>0){
            let m = JSON.parse(sels[0].get('marks'));
            if (m[id]=='X'){
                m[id]='O';
            }else{
                m[id]='X';
            }
            sels[0].set('marks',JSON.stringify(m));
            sels[0].commit();
            Tualo.Fetch.post('papervote/opticaledit',{
                id: sels[0].get('pagination_id'),
                marks: JSON.stringify(m)
            }).then(function(data){
                me.onSelect.bind(me)( null, me.getView().down('#docs').getSelection()[0], null, null )
                console.log('data',data);
                me.getView().setDisabled(false);
            });
            // console.log('marks',sels[0].data);
        }
        
    },
    
    onBoxReady: function () {
        var me = this;
        console.log('box ready');
        
        var store = me.getViewModel().getStore('papervote_optical');
        store.load();
       
    }
  });