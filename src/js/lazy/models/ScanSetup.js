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
        let txt='XYZ';
        return txt;
      }
    },
    stores: {
        
      wahlscheinstatus: {
        autoLoad: false,
        type: 'wahlscheinstatus_store',
        listeners: {
          // load: 'onWahlscheinstatusLoad'
        }
      },
      
    }
  });
  