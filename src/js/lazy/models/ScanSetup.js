Ext.define('Tualo.PaperVoteOptical.lazy.models.ScanSetup', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.papervote_optical_scan_setup',
    data: {
      modell: 'Handerfassung',
      regiogruppe: 'Zustellung',
      sortiergang: 'rest',
      blocknumber: '',
      
      useident: false,
      list_length: 1,
      count: 0
    },
    formulas: {
      ftitle: function(get){
        let txt='Konfiguratuion der Stimmzettellesung';
        return txt;
      }
    },
    stores: {
        
      stimmzettel: {
        type: 'stimmzettel_store',
        autoLoad: true
      },

      stimmzettel_roi: {
        type: 'stimmzettel_roi_store',
        autoLoad: false
      },

      sz_rois: {
          type: 'sz_rois_store',
          autoLoad: false,
          listeners: {
            write: 'onRoisWrite'
          }
      },
       
      kandidaten_bp_column: {
        autoLoad: false,
        type: 'kandidaten_bp_column_store',
        listeners: {
          datachanged: 'onCandidatesDataChanged'
        }
      }
      
    }
  });
  