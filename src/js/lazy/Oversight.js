Ext.define('Tualo.PaperVoteOptical.lazy.Oversight', {
    extend: 'Ext.panel.Panel',
    requires: [
        'Tualo.PaperVoteOptical.lazy.models.Oversight',
        'Tualo.PaperVoteOptical.lazy.controller.Oversight'
    ],
    alias: 'widget.papervote_optical_oversight',
    controller: 'papervote_optical_oversight',

    viewModel: {
        type: 'papervote_optical_oversight'
    },
    listeners: {
        boxReady: 'onBoxReady'
    },

    layout: 'border',
    bind: {
        title: '{ftitle}'
    },
    items: [

        {
            xtype: 'grid',
            itemId: 'docs',
            region: 'west',
            flex: 1,
            hidden: false,
            listeners: {
                select: 'onSelect'
            },

            bind: {
                store: '{papervote_optical}'
            },


            columns: [{
                header: 'ID',
                dataIndex: 'pagination_id',
                flex: 1,
                renderer: function (value, metaData, record) {

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
                }
            }, {
                hidden: true,
                header: 'Markierungen',
                dataIndex: 'marks',
                flex: 1
            }]
        },
        {
            xtype: 'grid',
            itemId: 'marks',
            region: 'east',

            flex: 1,
            listeners: {
                select: 'onSelectCandidate'
            },
            hidden: true,
            store: {
                type: 'array',
                fields: [
                    'pagination_id',
                    'stimmzettel_id',
                    'stimmzettel_name',
                    'anzeige_name',
                    'pos',
                    'marked'
                ]
            },
            columns: [{
                header: 'Kandidat',
                dataIndex: 'anzeige_name',
                flex: 1
            }, {
                header: 'Gewählt',
                dataIndex: 'marked',
                flex: 1
            }]
        },
        {
            xtype: 'component',
            split: true,
            itemId: 'image',
            scrollable: 'y',

            flex: 3,
            region: 'center',
            src: '',
            //style: 'object-fit: contain; width: 100%; height: 100%;',

        }
    ],

    dockedItems: [
        {
            xtype: 'toolbar',
            dock: 'bottom',
            reference: 'buttonDock'
        },
        {
            xtype: 'toolbar',
            dock: 'bottom',

            items: [
                {
                    xtype: 'label',
                    html: '',
                    style: 'font-size: 1.3em;line-height: 32px',
                    reference: 'message'
                }
            ]
        }
    ],
});
