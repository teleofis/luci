'use strict';
'require baseclass';
'require form';
'require fs';

return baseclass.extend({
	trigger: _('Serial port activity (kernel: tty)'),
	description: _('The LED flashes with data transmission and reception on the configured serial port.'),
	kernel: true,
	addFormOptions: function(s) {
		var o;

		o = s.option(form.Value, '_tty_dev', _('Device'));
		o.rmempty = true;
		o.ucioption = 'dev';
		o.modalonly = true;
		o.depends('trigger', 'tty');
		o.load = function(section_id) {
			return L.resolveDefault(fs.list('/dev'), []).then(L.bind(function(entries) {
				var names = [];

				for (var i = 0; i < entries.length; i++)
					if (entries[i].name.match(/^tty(S|USB|ACM|AMA|mxc)\d+$/))
						names.push(entries[i].name);

				names.sort(L.naturalCompare).forEach(L.bind(function(name) {
					if (!this.keylist || this.keylist.indexOf(name) < 0)
						this.value(name);
				}, this));

				return form.Value.prototype.load.apply(this, [section_id]);
			}, this));
		};
	}
});
