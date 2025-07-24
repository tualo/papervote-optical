Ext.define('Tualo.PaperVoteOptical.lazy.ScanSetup', {
    extend: 'Ext.panel.Panel',
    requires: [
        'Tualo.PaperVoteOptical.lazy.models.ScanSetup',
        'Tualo.PaperVoteOptical.lazy.controller.ScanSetup'
    ],
    alias: 'widget.papervote_optical_scan_setup',
    controller: 'papervote_optical_scan_setup',

    viewModel: {
        type: 'papervote_optical_scan_setup'
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
            xtype: 'toolbar',
            region: 'north',
            items: [
                {
                    xtype: 'panel',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    flex: 1,
                    items: [
                        {
                            xtype: 'combobox_stimmzettel_id',
                            fieldLabel: 'Stimmzettel',
                            labelWidth: 80,
                            flex: 1,
                            listeners: {
                                change: 'onChooseBallotpaper'
                            }
                        },
                        {
                            xtype: 'combobox',
                            itemId: 'drawMode',
                            fieldLabel: 'Modus',
                            labelWidth: 80,
                            width: 300,
                            editable: false,
                            store: {
                                type: 'array',
                                fields: ['value', 'text'],
                                data: [
                                    ['rois', 'ROIs'],
                                    ['title_regions', 'SZ-Erkennungsbereiche']
                                ]
                            },
                            displayField: 'text',
                            valueField: 'value',
                            queryMode: 'local',
                            value: 'rois',

                            bind: {
                                value: '{drawMode}'
                            },
                            listeners: {
                                change: 'onDrawModeChange'
                            }
                        },

                        /*{
                            xtype: 'button',
                            text: 'Speichern',
                            handler: function(){
                                var me = this;
                                me.getView().setDisabled(true);
                                var sels = me.getView().down('#docs').getSelection();
                                if (sels.length>0){
                                    let m = JSON.parse(sels[0].get('marks'));
                                    Tualo.Fetch.post('papervote/opticaledit',{
                                        id: sels[0].get('pagination_id'),
                                        marks: JSON.stringify(m)
                                    }).then(function(data){
                                        me.onSelect.bind(me)( null, me.getView().down('#docs').getSelection()[0], null, null )
                                        console.log('data',data);
                                        me.getView().setDisabled(false);
                                    });
                                }
                            }
                        }*/
                    ],
                }

            ]
        },
        {
            xtype: 'panel',
            region: 'west',
            split: true,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            flex: 1,
            items: [
                {
                    xtype: 'grid',
                    itemId: 'docs',
                    flex: 1,
                    hidden: false,
                    listeners: {
                        select: 'onSelect'
                    },

                    bind: {
                        store: '{sz_rois}'
                    },

                    columns: [{
                        header: 'Name',
                        dataIndex: 'name',
                        flex: 1
                    }, {
                        header: 'ID',
                        dataIndex: 'id',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'X',
                        dataIndex: 'x',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Y',
                        dataIndex: 'y',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Width',
                        dataIndex: 'width',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Height',
                        dataIndex: 'height',
                        hidden: true,
                        flex: 1
                    }, {
                        text: ' ',
                        width: 42,

                        // This is our Widget column
                        xtype: 'widgetcolumn',
                        widget: {
                            xtype: 'glyphtool',
                            glyph: 'circle-minus',
                            darkColor: true,
                            handler: 'onRowRemove'
                        }
                    }],
                },

                {
                    xtype: 'grid',
                    itemId: 'sz_titel_regions',
                    flex: 1,
                    hidden: false,
                    listeners: {
                        select: 'onSelectTitelRegion'
                    },

                    bind: {
                        store: '{sz_titel_regions}'
                    },

                    columns: [{
                        header: 'Name',
                        dataIndex: 'name',
                        flex: 1
                    }, {
                        header: 'ID',
                        dataIndex: 'id',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'X',
                        dataIndex: 'x',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Y',
                        dataIndex: 'y',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Width',
                        dataIndex: 'width',
                        hidden: true,
                        flex: 1
                    }, {
                        header: 'Height',
                        dataIndex: 'height',
                        hidden: true,
                        flex: 1
                    }, {
                        text: ' ',
                        width: 42,

                        // This is our Widget column
                        xtype: 'widgetcolumn',
                        widget: {
                            xtype: 'glyphtool',
                            glyph: 'circle-minus',
                            darkColor: true,
                            handler: 'onRowRemove'
                        }
                    }],
                }
            ]
        },
        {
            xtype: 'panel',
            scrollable: 'y',
            itemId: 'image',
            flex: 3,
            region: 'center',
            src: '',
            //style: 'object-fit: contain; width: 100%; height: 100%;',

        },
        {
            xtype: 'grid',
            split: true,
            itemId: 'candidates',
            region: 'east',
            flex: 1,
            hidden: false,
            listeners: {
                //select: 'onSelect'
            },

            bind: {
                store: '{kandidaten_bp_column}'
            },

            viewConfig: {
                plugins: {
                    ptype: 'gridviewdragdrop',
                },
                listeners: {
                    drop: 'onDropGrid'
                }
            },
            columns: [{
                header: 'P',
                dataIndex: 'position',
                flex: 1
            }, {
                header: 'Name',
                dataIndex: 'anzeige_name',
                flex: 4
            }, {
                xtype: 'checkcolumn',
                header: 'aktiv',
                dataIndex: 'kandidaten_id_checked',
                flex: 1
            }],
        },
    ],/*
    dockedItems: [
        {
            xtype: 'toolbar',
            dock: 'bottom',
            reference: 'buttonDock'
        }, {
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
    ],*/
});
