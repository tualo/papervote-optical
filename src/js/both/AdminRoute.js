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



Ext.define('Tualo.routes.PaperVoteOptical.AdminRouteClick', {
    statics: {
        load: async function() {
            return [ ]
        }
    }, 
    url: 'papervote-optical/oversightclick/svg/:id',
    handler: {
        action: function (id,action) {
            let mainView = Ext.getApplication().getMainView(),
                stage = mainView.getComponent('dashboard_dashboard').getComponent('stage'),
                component = null,
                cmp_id = 'papervote_optical_oversight';
                component = stage.down(cmp_id);
            if (component){
                
                component.setDisabled(true);
                setTimeout(()=>{
                    component.getController().onSvgClick(id);
                    
                    Ext.getApplication().redirectTo('#papervote-optical/oversight');
                },10);
                
            }else{
                // action.reject();
            }
        },
        before: function (id,action) {
            action.resume();
        }
    }
});