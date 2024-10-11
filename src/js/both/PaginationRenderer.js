
Ext.define('Tualo.PaperVoteOptical.Format', {
    singleton: true,
    paginationRenderer:  function (value, metaData, record) {

        if ((record.get('stimmzettelgruppen_enthaltung') == 1) || (record.get('stimmzettelgruppen_enthaltung') === true)) {
            metaData.tdStyle = 'background-color: rgba(255,255,0,0.5);;';
        }

        if ((record.get('stimmzettelgruppen_ungueltig') == 1) || (record.get('stimmzettelgruppen_ungueltig') === true)) {
            metaData.tdStyle = 'background-color: rgba(255,50,0,0.5);';
        }

        if ((record.get('stimmzettel_enthaltung') == 1) || (record.get('stimmzettel_enthaltung') === true)) {
            metaData.tdStyle = 'background-color: rgba(255,255,0,0.5);;';
        }


        if ((record.get('stimmzettel_ungueltig') == 1) || (record.get('stimmzettel_ungueltig') === true)) {
            metaData.tdStyle = 'background-color: rgba(255,0,0,0.5);';
        }




        return value;
    },
    papervoteCheckRenderer: function (value, metaData, record) {
        if (value==1 || value==true ){
            return '<i class="fa-solid fa-square-check"></i>';
        }
        return '<i class="fa-solid fa-square"></i>';

    }
});

Ext.merge(Ext.util.Format, {
    paginationRenderer: Tualo.PaperVoteOptical.paginationRenderer,
    papervoteCheckRenderer: Tualo.PaperVoteOptical.papervoteCheckRenderer,
});
