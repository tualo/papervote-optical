Ext.define('Tualo.PaperVoteOptical.lazy.models.Oversight', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.papervote_optical_oversight',
    data: {

      count: 0
    },
    formulas: {
      ftitle: function(get){
        let txt='',typ='Prüfung per Stimmzettel';
        return typ+txt+'';
      }
    },
    stores: {
        
        papervote_optical: {
          autoLoad: false,
          type: 'view_papervote_optical_result_store',
          listeners: {
            load: 'onPapervoteOpticalLoad'
          }
        },

        view_papervote_optical_result: {
          autoLoad: false,
          type: 'view_papervote_optical_result_store',
          listeners: {
            load: 'onPapervoteOpticalResultLoad'
          }
        },
      
    }
  });
  