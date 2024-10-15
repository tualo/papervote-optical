Ext.define('Tualo.PaperVoteOptical.lazy.controller.Oversight', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.papervote_optical_oversight',

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


    onRefresh: function(){
        this.getViewModel().getStore('papervote_optical').load();
    },

    onPreProcessed: function (id) {
        console.log('svg click',id);
        var me = this;
            sels = me.getView().down('#docs').getSelection();
        if (sels.length>0){
            Tualo.Fetch.post('papervote/opticaledit/pre_processed',{
                id: sels[0].get('pagination_id')
            }).then(function(data){
                me.onSelect.bind(me)( null, me.getView().down('#docs').getSelection()[0], null, null )
                if (data.success==false){
                    Ext.toast({
                        html: data.msg,
                        title: 'Fehler',
                        align: 't',
                        iconCls: 'fa fa-warning'
                    });
                }
                console.log('data',data);
                me.getView().setDisabled(false);
                me.getViewModel().getStore('papervote_optical').load();
            });
            // console.log('marks',sels[0].data);
        }
        
    },

    onConfirmed: function (id) {
        console.log('svg click',id);
        var me = this;
            sels = me.getView().down('#docs').getSelection();
        if (sels.length>0){
            Tualo.Fetch.post('papervote/opticaledit/confirm',{
                id: sels[0].get('pagination_id')
            }).then(function(data){
                me.onSelect.bind(me)( null, me.getView().down('#docs').getSelection()[0], null, null )
                console.log('data',data);
                if (data.success==false){
                    Ext.toast({
                        html: data.msg,
                        title: 'Fehler',
                        align: 't',
                        iconCls: 'fa fa-warning'
                    });
                }
                me.getView().setDisabled(false);
                me.getViewModel().getStore('papervote_optical').load();
            });
            // console.log('marks',sels[0].data);
        }
        
    },

    onRejected: function (id) {
        console.log('svg click',id);
        var me = this;
            sels = me.getView().down('#docs').getSelection();
        if (sels.length>0){
            Tualo.Fetch.post('papervote/opticaledit/reject',{
                id: sels[0].get('pagination_id')
            }).then(function(data){
                me.onSelect.bind(me)( null, me.getView().down('#docs').getSelection()[0], null, null )
                console.log('data',data);
                if (data.success==false){
                    Ext.toast({
                        html: data.msg,
                        title: 'Fehler',
                        align: 't',
                        iconCls: 'fa fa-warning'
                    });
                }
                me.getView().setDisabled(false);
                me.getViewModel().getStore('papervote_optical').load();
            });
            // console.log('marks',sels[0].data);
        }
        
    },

    readPermissions: async function(){
        let me = this;
            data = await Tualo.Fetch.get('papervote/opticaledit/permissions'),
            view = me.getView(),
            buttonDock = view.getComponent('buttonDock')
            preProcessedButton = buttonDock.getComponent('preProcessedButton');

            if (data.success){
                if (data.data.confirm===false) confirmButton.setDisabled(true);
                if (data.data.reject===false) rejectButton.setDisabled(true);
                if (data.data.pre_processed===false) preProcessedButton.setDisabled(true);
            }
    },
    
    onBoxReady: function () {
        var me = this;
        console.log('box ready');
        
        var store = me.getViewModel().getStore('papervote_optical');
        store.load();
       
        me.readPermissions();
    },
    onPapervoteOpticalLoad: function (store, records, successful, operation, eOpts) {
        console.log('store loaded',records);
        var me = this;
        me.getView().down('#docs').getStore().loadData(records);
        setTimeout(function(){
            me.getView().down('#docs').setSelection(records[0]);
        });
    },
    onPapervoteOpticalResultLoad: function (store, records, successful, operation, eOpts) {
        console.log('store loaded',records);
        var me = this;
        me.getView().down('#marks').getStore().loadData(records);
    },
    onSelect:  function( grid, record, index, eOpts ){
        var me = this;
        //me.getView().down('#image').setSrc('./papervote/opticalimagesvg/'+record.get('pagination_id'));
        fetch('./papervote/opticalimagesvg/'+record.get('pagination_id')).then(function(response){
            return response.text();
        }).then(function(data){
            me.getView().down('#image').setHtml(data);
        });
        
        console.log('select',record);
        var store = me.getViewModel().getStore('view_papervote_optical_result');
        store.load({
            params: {
              filter: Ext.JSON.encode([{ property: 'pagination_id', value: record.get('pagination_id'), operator: 'eq' }])
            }
          });

    },
    onSelectCandidate:  function( grid, record, index, eOpts ){
        var me = this;
        console.log('select candidate',record);
    }
  });