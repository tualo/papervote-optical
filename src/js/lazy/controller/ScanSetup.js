Ext.define('Tualo.PaperVoteOptical.lazy.controller.ScanSetup', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.papervote_optical_scan_setup',

    onDropGrid: function () {
        this.numberRows();
    },

    numberRows: function () {
        var i,
            me = this,
            model = me.getViewModel(),
            store = model.getStore('kandidaten_bp_column'),
            records = store.getRange(),
            min = Number.POSITIVE_INFINITY,
            fld_name = 'position';
        if (!Ext.isEmpty(fld_name)) {
            min = 1;
            for (i = 0; i < records.length; i++) {
                console.log('onDropGrid', records[i], fld_name, min + i);
                records[i].set(fld_name, min + i);
            }
            store.sync();
        }

    },

    onChooseBallotpaper: function (f, value) {
        if (value) {
            //this.getView().getViewModel().getStore('sz_rois').removeAll();

            let sz_rois = this.getView().getViewModel().getStore('sz_rois');
            sz_rois.clearFilter();
            sz_rois.filter([
                {
                    property: 'stimmzettel_id',
                    operator: 'like',
                    value: value
                }
            ]);
            sz_rois.load({
                callback: function (records, operation, success) {
                    console.log('sz_rois', records);
                    // item_cap_y
                    // item_height

                }.bind(this)
            });

            let sz_titel_regions = this.getView().getViewModel().getStore('sz_titel_regions');
            sz_titel_regions.clearFilter();
            sz_titel_regions.filter([
                {
                    property: 'id_sz',
                    operator: 'eq',
                    value: value
                }
            ]);
            sz_titel_regions.load({
                callback: function (records, operation, success) {
                    // item_cap_y
                    // item_height

                }.bind(this)
            });


            let stimmzettel_roi = this.getViewModel().getStore('stimmzettel_roi');
            stimmzettel_roi.clearFilter();
            stimmzettel_roi.filter([
                {
                    property: 'stimmzettel_id',
                    operator: 'like',
                    value: value
                }
            ]);
            stimmzettel_roi.load();

            this.loadImage(value);
        }
    },

    colors: {
        'unselected': 'blue',
        'selected': 'green',
        'draw': 'red'
    },

    onSvgClick: function (id) {
        console.log('svg click', id);
        var me = this;
        sels = me.getView().down('#docs').getSelection();
        if (sels.length > 0) {
            let m = JSON.parse(sels[0].get('marks'));
            if (m[id] == 'X') {
                m[id] = 'O';
            } else {
                m[id] = 'X';
            }
            sels[0].set('marks', JSON.stringify(m));
            sels[0].commit();
            Tualo.Fetch.post('papervote/opticaledit', {
                id: sels[0].get('pagination_id'),
                marks: JSON.stringify(m)
            }).then(function (data) {
                me.onSelect.bind(me)(null, me.getView().down('#docs').getSelection()[0], null, null)
                console.log('data', data);
                me.getView().setDisabled(false);
            });
            // console.log('marks',sels[0].data);
        }

    },
    onRowRemove: function (evt, el, x, item) {
        var me = this;
        let sz_rois = me.getView().getViewModel().getStore('sz_rois');
        let stimmzettel_roi = this.getViewModel().getStore('stimmzettel_roi');


        let rx = stimmzettel_roi.findRecord('sz_rois_id', item.$widgetRecord.get('id'), 0, false, false, true);

        /*
        stimmzettel_roi.getRange().forEach(function (record) {
            if (record.get('sz_rois_id')==item.$widgetRecord.get('id')){
                console.log('remove',record);
                stimmzettel_roi.remove(record);
            }
        });
        stimmzettel_roi.sync();
        */
        stimmzettel_roi.remove(rx);
        stimmzettel_roi.sync();

        console.log('widgetRecord', rx);
        sz_rois.remove(item.$widgetRecord);
        stimmzettel_roi.sync();

        me.drawRectsByStore();
    },
    onBoxReady: function () {
        var me = this;

    },

    loadImage: async function (ballotpaper_id) {
        var me = this;
        me.stimmzettel_id = ballotpaper_id;
        me.stimmzettelName = me.getViewModel().getStore('stimmzettel').findRecord('id', ballotpaper_id, 0, false, false, true).get('name');

        let response = await fetch('./papervoteoptical/image/' + ballotpaper_id);
        let data = await response.text();
        me.getView().down('#image').setHtml(data);

        setTimeout(function () {

            me.setupRect(document.querySelector('svg'));


        }, 2000);
        me.drawRectsByStore();
        console.log('image loaded', me.getView().down('#image').getEl());
    },
    drawRectsByStore: function () {
        var me = this;
        let store = me.getViewModel().getStore('sz_rois');
        let svg = document.querySelector('svg');
        let rects = document.querySelectorAll('rect');
        for (let i = 0; i < rects.length; i++) {
            rects[i].remove();
        }





        Ext.Array.each(store.getRange(), function (record) {
            console.log('store', record);
            const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            rect.setAttributeNS(null, 'id', 'rect' + record.get('id'));
            rect.setAttributeNS(null, 'fill', 'none');
            rect.setAttributeNS(null, 'stroke', me.colors.unselected);
            rect.setAttributeNS(null, 'stroke-width', '4');
            rect.setAttributeNS(null, 'x', record.get('x') * 144 / 2.54 / 10);
            rect.setAttributeNS(null, 'y', record.get('y') * 144 / 2.54 / 10);
            rect.setAttributeNS(null, 'width', record.get('width') * 144 / 2.54 / 10);
            rect.setAttributeNS(null, 'height', record.get('height') * 144 / 2.54 / 10);
            svg.appendChild(rect);
        });
    },

    setupRect: function (svg) {
        var me = this;

        const svgPoint = (elem, x, y) => {
            const p = svg.createSVGPoint();
            p.x = x;
            p.y = y;
            return p.matrixTransform(elem.getScreenCTM().inverse());
        };



        svg.addEventListener('mousedown', (event) => {
            me.id = Math.round(((new Date()).getTime() - (new Date('2024-01-01')).getTime()) / 1000);

            let ratioX =
                document.querySelector('svg').width.baseVal.value /
                document.querySelector('svg').querySelector('image').width.baseVal.value;

            let ratioY =
                document.querySelector('svg').height.baseVal.value /
                document.querySelector('svg').querySelector('image').height.baseVal.value;
            me.ratioX = ratioX;
            me.ratioY = ratioY;


            const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            rect.setAttributeNS(null, 'id', 'rect' + me.id);
            rect.setAttributeNS(null, 'fill', 'none');
            rect.setAttributeNS(null, 'stroke', me.colors.draw);
            rect.setAttributeNS(null, 'stroke-width', '4');

            rect.id = 'rect' + me.id;

            const start = svgPoint(svg, event.clientX, event.clientY);
            const drawRect = (e) => {


                //console.log('click',e.offsetX /144*2.54/ratioX ,e.offsetY /144*2.54/ ratioY);

                const p = svgPoint(svg, e.clientX, e.clientY);
                const w = Math.abs(p.x - start.x);
                const h = Math.abs(p.y - start.y);
                if (p.x > start.x) {
                    p.x = start.x;
                }

                if (p.y > start.y) {
                    p.y = start.y;
                }

                rect.setAttributeNS(null, 'x', p.x);
                rect.setAttributeNS(null, 'y', p.y);
                rect.setAttributeNS(null, 'width', w);
                rect.setAttributeNS(null, 'height', h);
                svg.appendChild(rect);
            };

            const endDraw = (e) => {
                svg.removeEventListener('mousemove', drawRect);
                svg.removeEventListener('mouseup', endDraw);

                me.onEndDraw(e, rect);
                /*
                let o = {
                    id: me.id,
                    name: me.stimmzettelName + ' ROI ' + me.id,
                    x: rect.getAttribute('x') / 144 * 2.54 * 10,
                    y: rect.getAttribute('y') / 144 * 2.54 * 10,
                    width: rect.getAttribute('width') / 144 * 2.54 * 10,
                    height: rect.getAttribute('height') / 144 * 2.54 * 10
                };
                let r = me.getViewModel().getStore('sz_rois').add(o);
                me.getViewModel().getStore('sz_rois').sync({
                    callback: function (o, opts) {
                        console.log('sync callback', arguments);
                        console.log('sync callback', opts.operations);
                        console.log('sync callback', opts.operations.create);
                        opts.operations.create.forEach(function (record) {

                            if (me.getViewModel().get('drawMode') == 'rois') {
                                me.getViewModel().getStore('stimmzettel_roi').add({
                                    stimmzettel_id: me.stimmzettel_id,
                                    sz_rois_id: record.data.id
                                });
                                me.getViewModel().getStore('stimmzettel_roi').sync();
                            }


                            console.log('sync callback', record.data.id);
                        });
                    }
                });
                //me.onSelect.bind(me)( null, r[0], null, null )
                */

            };

            svg.addEventListener('mousemove', drawRect);
            svg.addEventListener('mouseup', endDraw);
        });
    },

    onEndDraw: function (e, rect) {
        var me = this;
        if (me.getViewModel().get('drawMode') == 'rois') {
            me.onEndDrawRois(e, rect);
        } else if (me.getViewModel().get('drawMode') == 'title_regions') {
            me.onEndDrawTitleRegions(e, rect);
        } else {
            console.warn('Unknown draw mode', me.getViewModel().get('drawMode'));
        }
    },

    onEndDrawRois: function (e, rect) {
        var me = this;
        let o = {
            id: me.id,
            name: me.stimmzettelName + ' ROI ' + me.id,
            x: rect.getAttribute('x') / 144 * 2.54 * 10,
            y: rect.getAttribute('y') / 144 * 2.54 * 10,
            width: rect.getAttribute('width') / 144 * 2.54 * 10,
            height: rect.getAttribute('height') / 144 * 2.54 * 10
        };
        let r = me.getViewModel().getStore('sz_rois').add(o);
        me.getViewModel().getStore('sz_rois').sync({
            callback: function (o, opts) {
                console.log('sync callback', arguments);
                console.log('sync callback', opts.operations);
                console.log('sync callback', opts.operations.create);
                opts.operations.create.forEach(function (record) {


                    me.getViewModel().getStore('stimmzettel_roi').add({
                        stimmzettel_id: me.stimmzettel_id,
                        sz_rois_id: record.data.id
                    });
                    me.getViewModel().getStore('stimmzettel_roi').sync();

                    console.log('sync callback', record.data.id);
                });
            }
        });
        //me.onSelect.bind(me)( null, r[0], null, null )

    },

    onEndDrawTitleRegions: function (e, rect) {
        var me = this;

        let o = {
            id: me.id,
            name: me.stimmzettelName + ' Titelregion ' + me.id,
            x: rect.getAttribute('x') / 144 * 2.54 * 10,
            y: rect.getAttribute('y') / 144 * 2.54 * 10,
            width: rect.getAttribute('width') / 144 * 2.54 * 10,
            height: rect.getAttribute('height') / 144 * 2.54 * 10
        };
        let r = me.getViewModel().getStore('sz_titel_regions').add(o);
        me.getViewModel().getStore('sz_titel_regions').sync({
            callback: function (o, opts) {
                console.log('sync callback', arguments);
                console.log('sync callback', opts.operations);
                console.log('sync callback', opts.operations.create);
                console.log('sync me.stimmzettel_id,', me.stimmzettel_id);
                opts.operations.create.forEach(function (record) {

                    me.getViewModel().getStore('sz_to_region').add({
                        id_sz: me.stimmzettel_id,
                        id_sz_titel_regions: record.data.id
                    });
                    me.getViewModel().getStore('sz_to_region').sync();

                    console.log('sync callback', record.data.id);
                });
            }
        });
    },

    onTitelRegionsWrite: function (store) {
        var me = this;
        console.log('write', arguments);
    },

    onRoisWrite: function (store) {
        var me = this;
        console.log('write', arguments);
    },
    onCandidatesDataChanged: function (store) {
        var me = this;
        console.log('onCandidatesDataChanged', arguments);
        store.sync();
    },
    onSelect: function (grid, record, index, eOpts) {
        var me = this;


        let rects = document.querySelectorAll('rect');
        for (let i = 0; i < rects.length; i++) {
            rects[i].setAttributeNS(null, 'stroke', 'blue');
            rects[i].setAttributeNS(null, 'stroke-width', '4');
        }

        let rect = document.querySelector('rect#rect' + record.get('id'));
        if (rect) {
            rect.setAttributeNS(null, 'stroke', me.colors.selected);
            rect.setAttributeNS(null, 'stroke-width', '8');
            //rect.remove();


        }
        // me.loadImage(record.get('ballotpaper_id'));

        let kandidaten = me.getViewModel().getStore('kandidaten_bp_column');
        kandidaten.clearFilter();

        var sorters = kandidaten.getSorters(); // an Ext.util.SorterCollection
        sorters.clear();
        sorters.add('stimmzettelgruppen_id');
        sorters.add('position');

        kandidaten.filter([
            {
                property: 'stimmzettel_id',
                operator: 'like',
                value: me.stimmzettel_id + ""
            },
            {
                property: 'sz_rois_id',
                operator: 'like',
                value: record.get('id')
            }
        ]);
        kandidaten.load();
    }
});
