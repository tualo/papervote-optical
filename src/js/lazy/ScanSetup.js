Ext.define('Tualo.PaperVoteOptical.lazy.ScanSetup', {
    extend: 'Ext.panel.Panel',
    requires: [
        'Tualo.PaperVoteOptical.lazy.models.ScanSetup',
        'Tualo.PaperVoteOptical.lazy.controller.ScanSetup'
    ],
    alias: 'widget.papervote_opticalscan',
    controller: 'papervote_opticalscan',

    viewModel: {
        type: 'papervote_opticalscan'
    },
    listeners:{
            boxReady: 'onBoxReady'
    },

	layout: 'border',
    bind:{
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

            store: {
                type: 'array',
                fields: ['pagination_id','marks']
            },

            columns: [{
                header: 'ID',
                dataIndex: 'pagination_id',
                flex:1
            },{
                hidden: true,
                header: 'Markierungen',
                dataIndex: 'marks',
                flex:1
            }]
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
