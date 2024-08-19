Ext.define('Tualo.routes.PaperVoteOptical.ScanSetup', {
    statics: {
        load: async function() {
            return [
                {
                    name: 'papervote-optical/scan-setup',
                    path: '#papervote-optical/scan-setup'
                }
            ]
        }
    }, 
    url: 'papervote-optical/scan-setup',
    handler: {
        action: function () {
            
            let mainView = Ext.getApplication().getMainView(),
                stage = mainView.getComponent('dashboard_dashboard').getComponent('stage'),
                component = null,
                cmp_id = 'papervote_optical_scan_setup';
                component = stage.down(cmp_id);
            if (component){
                stage.setActiveItem(component);
            }else{
                Ext.getApplication().addView('Tualo.PaperVoteOptical.lazy.ScanSetup',{
                
                });
            }

            
        },
        before: function (action) {
            action.resume();
        }
    }
});