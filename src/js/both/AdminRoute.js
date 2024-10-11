Ext.define('Tualo.routes.PaperVoteOptical.AdminRoute', {
    statics: {
        load: async function() {
            return [
                {
                    name: 'papervote-optical/oversight',
                    path: '#papervote-optical/oversight'
                }
            ]
        }
    }, 
    url: 'papervote-optical/oversight',
    handler: {
        action: function () {
            
            let mainView = Ext.getApplication().getMainView(),
                stage = mainView.getComponent('dashboard_dashboard').getComponent('stage'),
                component = null,
                cmp_id = 'papervote_optical_oversight';
                component = stage.down(cmp_id);
            if (component){
                stage.setActiveItem(component);
            }else{
                Ext.getApplication().addView('Tualo.PaperVoteOptical.lazy.Oversight',{
                
                });
            }

            
        },
        before: function (action) {
            action.resume();
        }
    }
});