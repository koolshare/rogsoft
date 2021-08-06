var md5;
md5 || (md5 = function() {
	function i(a, b) {
		a[b >> 5] |= 128 << b % 32, a[(b + 64 >>> 9 << 4) + 14] = b;
		for (var c = 1732584193, d = -271733879, e = -1732584194, f = 271733878, g = 0; a.length > g; g += 16) {
			var h = c,
				i = d,
				j = e,
				o = f;
			c = k(c, d, e, f, a[g + 0], 7, -680876936), f = k(f, c, d, e, a[g + 1], 12, -389564586), e = k(e, f, c, d, a[g + 2], 17, 606105819), d = k(d, e, f, c, a[g + 3], 22, -1044525330), c = k(c, d, e, f, a[g + 4], 7, -176418897), f = k(f, c, d, e, a[g + 5], 12, 1200080426), e = k(e, f, c, d, a[g + 6], 17, -1473231341), d = k(d, e, f, c, a[g + 7], 22, -45705983), c = k(c, d, e, f, a[g + 8], 7, 1770035416), f = k(f, c, d, e, a[g + 9], 12, -1958414417), e = k(e, f, c, d, a[g + 10], 17, -42063), d = k(d, e, f, c, a[g + 11], 22, -1990404162), c = k(c, d, e, f, a[g + 12], 7, 1804603682), f = k(f, c, d, e, a[g + 13], 12, -40341101), e = k(e, f, c, d, a[g + 14], 17, -1502002290), d = k(d, e, f, c, a[g + 15], 22, 1236535329), c = l(c, d, e, f, a[g + 1], 5, -165796510), f = l(f, c, d, e, a[g + 6], 9, -1069501632), e = l(e, f, c, d, a[g + 11], 14, 643717713), d = l(d, e, f, c, a[g + 0], 20, -373897302), c = l(c, d, e, f, a[g + 5], 5, -701558691), f = l(f, c, d, e, a[g + 10], 9, 38016083), e = l(e, f, c, d, a[g + 15], 14, -660478335), d = l(d, e, f, c, a[g + 4], 20, -405537848), c = l(c, d, e, f, a[g + 9], 5, 568446438), f = l(f, c, d, e, a[g + 14], 9, -1019803690), e = l(e, f, c, d, a[g + 3], 14, -187363961), d = l(d, e, f, c, a[g + 8], 20, 1163531501), c = l(c, d, e, f, a[g + 13], 5, -1444681467), f = l(f, c, d, e, a[g + 2], 9, -51403784), e = l(e, f, c, d, a[g + 7], 14, 1735328473), d = l(d, e, f, c, a[g + 12], 20, -1926607734), c = m(c, d, e, f, a[g + 5], 4, -378558), f = m(f, c, d, e, a[g + 8], 11, -2022574463), e = m(e, f, c, d, a[g + 11], 16, 1839030562), d = m(d, e, f, c, a[g + 14], 23, -35309556), c = m(c, d, e, f, a[g + 1], 4, -1530992060), f = m(f, c, d, e, a[g + 4], 11, 1272893353), e = m(e, f, c, d, a[g + 7], 16, -155497632), d = m(d, e, f, c, a[g + 10], 23, -1094730640), c = m(c, d, e, f, a[g + 13], 4, 681279174), f = m(f, c, d, e, a[g + 0], 11, -358537222), e = m(e, f, c, d, a[g + 3], 16, -722521979), d = m(d, e, f, c, a[g + 6], 23, 76029189), c = m(c, d, e, f, a[g + 9], 4, -640364487), f = m(f, c, d, e, a[g + 12], 11, -421815835), e = m(e, f, c, d, a[g + 15], 16, 530742520), d = m(d, e, f, c, a[g + 2], 23, -995338651), c = n(c, d, e, f, a[g + 0], 6, -198630844), f = n(f, c, d, e, a[g + 7], 10, 1126891415), e = n(e, f, c, d, a[g + 14], 15, -1416354905), d = n(d, e, f, c, a[g + 5], 21, -57434055), c = n(c, d, e, f, a[g + 12], 6, 1700485571), f = n(f, c, d, e, a[g + 3], 10, -1894986606), e = n(e, f, c, d, a[g + 10], 15, -1051523), d = n(d, e, f, c, a[g + 1], 21, -2054922799), c = n(c, d, e, f, a[g + 8], 6, 1873313359), f = n(f, c, d, e, a[g + 15], 10, -30611744), e = n(e, f, c, d, a[g + 6], 15, -1560198380), d = n(d, e, f, c, a[g + 13], 21, 1309151649), c = n(c, d, e, f, a[g + 4], 6, -145523070), f = n(f, c, d, e, a[g + 11], 10, -1120210379), e = n(e, f, c, d, a[g + 2], 15, 718787259), d = n(d, e, f, c, a[g + 9], 21, -343485551), c = p(c, h), d = p(d, i), e = p(e, j), f = p(f, o)
		}
		return [c, d, e, f]
	}

	function j(a, b, c, d, e, f) {
		return p(q(p(p(b, a), p(d, f)), e), c)
	}

	function k(a, b, c, d, e, f, g) {
		return j(b & c | ~b & d, a, b, e, f, g)
	}

	function l(a, b, c, d, e, f, g) {
		return j(b & d | c & ~d, a, b, e, f, g)
	}

	function m(a, b, c, d, e, f, g) {
		return j(b ^ c ^ d, a, b, e, f, g)
	}

	function n(a, b, c, d, e, f, g) {
		return j(c ^ (b | ~d), a, b, e, f, g)
	}

	function p(a, b) {
		var c = (a & 65535) + (b & 65535),
			d = (a >> 16) + (b >> 16) + (c >> 16);
		return d << 16 | c & 65535
	}

	function q(a, b) {
		return a << b | a >>> 32 - b
	}

	function r(a) {
		for (var b = [], d = (1 << c) - 1, e = 0; a.length * c > e; e += c) b[e >> 5] |= (a.charCodeAt(e / c) & d) << e % 32;
		return b
	}

	function t(b) {
		for (var c = a ? "0123456789ABCDEF" : "0123456789abcdef", d = "", e = 0; b.length * 4 > e; e++) d += c.charAt(b[e >> 2] >> e % 4 * 8 + 4 & 15) + c.charAt(b[e >> 2] >> e % 4 * 8 & 15);
		return d
	}
	var a = 0,
		c = 8;
	return function(a) {
		return t(i(r(a), a.length * c))
	}
}());
var b64map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var b64padchar = "=";

function hex2b64(h) {
	var i;
	var c;
	var ret = "";
	for (i = 0; i + 3 <= h.length; i += 3) {
		c = parseInt(h.substring(i, i + 3), 16);
		ret += b64map.charAt(c >> 6) + b64map.charAt(c & 63)
	}
	if (i + 1 == h.length) {
		c = parseInt(h.substring(i, i + 1), 16);
		ret += b64map.charAt(c << 2)
	} else {
		if (i + 2 == h.length) {
			c = parseInt(h.substring(i, i + 2), 16);
			ret += b64map.charAt(c >> 2) + b64map.charAt((c & 3) << 4)
		}
	}
	while ((ret.length & 3) > 0) {
		ret += b64padchar
	}
	return ret
}

function b64tohex(s) {
	var ret = "";
	var i;
	var k = 0;
	var slop;
	for (i = 0; i < s.length; ++i) {
		if (s.charAt(i) == b64padchar) {
			break
		}
		v = b64map.indexOf(s.charAt(i));
		if (v < 0) {
			continue
		}
		if (k == 0) {
			ret += int2char(v >> 2);
			slop = v & 3;
			k = 1
		} else {
			if (k == 1) {
				ret += int2char((slop << 2) | (v >> 4));
				slop = v & 15;
				k = 2
			} else {
				if (k == 2) {
					ret += int2char(slop);
					ret += int2char(v >> 2);
					slop = v & 3;
					k = 3
				} else {
					ret += int2char((slop << 2) | (v >> 4));
					ret += int2char(v & 15);
					k = 0
				}
			}
		}
	}
	if (k == 1) {
		ret += int2char(slop << 2)
	}
	return ret
}

function b64toBA(s) {
	var h = b64tohex(s);
	var i;
	var a = new Array();
	for (i = 0; 2 * i < h.length; ++i) {
		a[i] = parseInt(h.substring(2 * i, 2 * i + 2), 16)
	}
	return a
}
var dbits;
var canary = 244837814094590;
var j_lm = ((canary & 16777215) == 15715070);

function BigInteger(a, b, c) {
	if (a != null) {
		if ("number" == typeof a) {
			this.fromNumber(a, b, c)
		} else {
			if (b == null && "string" != typeof a) {
				this.fromString(a, 256)
			} else {
				this.fromString(a, b)
			}
		}
	}
}

function nbi() {
	return new BigInteger(null)
}

function am1(i, x, w, j, c, n) {
	while (--n >= 0) {
		var v = x * this[i++] + w[j] + c;
		c = Math.floor(v / 67108864);
		w[j++] = v & 67108863
	}
	return c
}

function am2(i, x, w, j, c, n) {
	var xl = x & 32767,
		xh = x >> 15;
	while (--n >= 0) {
		var l = this[i] & 32767;
		var h = this[i++] >> 15;
		var m = xh * l + h * xl;
		l = xl * l + ((m & 32767) << 15) + w[j] + (c & 1073741823);
		c = (l >>> 30) + (m >>> 15) + xh * h + (c >>> 30);
		w[j++] = l & 1073741823
	}
	return c
}

function am3(i, x, w, j, c, n) {
	var xl = x & 16383,
		xh = x >> 14;
	while (--n >= 0) {
		var l = this[i] & 16383;
		var h = this[i++] >> 14;
		var m = xh * l + h * xl;
		l = xl * l + ((m & 16383) << 14) + w[j] + c;
		c = (l >> 28) + (m >> 14) + xh * h;
		w[j++] = l & 268435455
	}
	return c
}
if (j_lm && (navigator.appName == "Microsoft Internet Explorer")) {
	BigInteger.prototype.am = am2;
	dbits = 30
} else {
	if (j_lm && (navigator.appName != "Netscape")) {
		BigInteger.prototype.am = am1;
		dbits = 26
	} else {
		BigInteger.prototype.am = am3;
		dbits = 28
	}
}
BigInteger.prototype.DB = dbits;
BigInteger.prototype.DM = ((1 << dbits) - 1);
BigInteger.prototype.DV = (1 << dbits);
var BI_FP = 52;
BigInteger.prototype.FV = Math.pow(2, BI_FP);
BigInteger.prototype.F1 = BI_FP - dbits;
BigInteger.prototype.F2 = 2 * dbits - BI_FP;
var BI_RM = "0123456789abcdefghijklmnopqrstuvwxyz";
var BI_RC = new Array();
var rr, vv;
rr = "0".charCodeAt(0);
for (vv = 0; vv <= 9; ++vv) {
	BI_RC[rr++] = vv
}
rr = "a".charCodeAt(0);
for (vv = 10; vv < 36; ++vv) {
	BI_RC[rr++] = vv
}
rr = "A".charCodeAt(0);
for (vv = 10; vv < 36; ++vv) {
	BI_RC[rr++] = vv
}

function int2char(n) {
	return BI_RM.charAt(n)
}

function intAt(s, i) {
	var c = BI_RC[s.charCodeAt(i)];
	return (c == null) ? -1 : c
}

function bnpCopyTo(r) {
	for (var i = this.t - 1; i >= 0; --i) {
		r[i] = this[i]
	}
	r.t = this.t;
	r.s = this.s
}

function bnpFromInt(x) {
	this.t = 1;
	this.s = (x < 0) ? -1 : 0;
	if (x > 0) {
		this[0] = x
	} else {
		if (x < -1) {
			this[0] = x + this.DV
		} else {
			this.t = 0
		}
	}
}

function nbv(i) {
	var r = nbi();
	r.fromInt(i);
	return r
}

function bnpFromString(s, b) {
	var k;
	if (b == 16) {
		k = 4
	} else {
		if (b == 8) {
			k = 3
		} else {
			if (b == 256) {
				k = 8
			} else {
				if (b == 2) {
					k = 1
				} else {
					if (b == 32) {
						k = 5
					} else {
						if (b == 4) {
							k = 2
						} else {
							this.fromRadix(s, b);
							return
						}
					}
				}
			}
		}
	}
	this.t = 0;
	this.s = 0;
	var i = s.length,
		mi = false,
		sh = 0;
	while (--i >= 0) {
		var x = (k == 8) ? s[i] & 255 : intAt(s, i);
		if (x < 0) {
			if (s.charAt(i) == "-") {
				mi = true
			}
			continue
		}
		mi = false;
		if (sh == 0) {
			this[this.t++] = x
		} else {
			if (sh + k > this.DB) {
				this[this.t - 1] |= (x & ((1 << (this.DB - sh)) - 1)) << sh;
				this[this.t++] = (x >> (this.DB - sh))
			} else {
				this[this.t - 1] |= x << sh
			}
		}
		sh += k;
		if (sh >= this.DB) {
			sh -= this.DB
		}
	}
	if (k == 8 && (s[0] & 128) != 0) {
		this.s = -1;
		if (sh > 0) {
			this[this.t - 1] |= ((1 << (this.DB - sh)) - 1) << sh
		}
	}
	this.clamp();
	if (mi) {
		BigInteger.ZERO.subTo(this, this)
	}
}

function bnpClamp() {
	var c = this.s & this.DM;
	while (this.t > 0 && this[this.t - 1] == c) {
		--this.t
	}
}

function bnToString(b) {
	if (this.s < 0) {
		return "-" + this.negate().toString(b)
	}
	var k;
	if (b == 16) {
		k = 4
	} else {
		if (b == 8) {
			k = 3
		} else {
			if (b == 2) {
				k = 1
			} else {
				if (b == 32) {
					k = 5
				} else {
					if (b == 4) {
						k = 2
					} else {
						return this.toRadix(b)
					}
				}
			}
		}
	}
	var km = (1 << k) - 1,
		d, m = false,
		r = "",
		i = this.t;
	var p = this.DB - (i * this.DB) % k;
	if (i-- > 0) {
		if (p < this.DB && (d = this[i] >> p) > 0) {
			m = true;
			r = int2char(d)
		}
		while (i >= 0) {
			if (p < k) {
				d = (this[i] & ((1 << p) - 1)) << (k - p);
				d |= this[--i] >> (p += this.DB - k)
			} else {
				d = (this[i] >> (p -= k)) & km;
				if (p <= 0) {
					p += this.DB;
					--i
				}
			} if (d > 0) {
				m = true
			}
			if (m) {
				r += int2char(d)
			}
		}
	}
	return m ? r : "0"
}

function bnNegate() {
	var r = nbi();
	BigInteger.ZERO.subTo(this, r);
	return r
}

function bnAbs() {
	return (this.s < 0) ? this.negate() : this
}

function bnCompareTo(a) {
	var r = this.s - a.s;
	if (r != 0) {
		return r
	}
	var i = this.t;
	r = i - a.t;
	if (r != 0) {
		return (this.s < 0) ? -r : r
	}
	while (--i >= 0) {
		if ((r = this[i] - a[i]) != 0) {
			return r
		}
	}
	return 0
}

function nbits(x) {
	var r = 1,
		t;
	if ((t = x >>> 16) != 0) {
		x = t;
		r += 16
	}
	if ((t = x >> 8) != 0) {
		x = t;
		r += 8
	}
	if ((t = x >> 4) != 0) {
		x = t;
		r += 4
	}
	if ((t = x >> 2) != 0) {
		x = t;
		r += 2
	}
	if ((t = x >> 1) != 0) {
		x = t;
		r += 1
	}
	return r
}

function bnBitLength() {
	if (this.t <= 0) {
		return 0
	}
	return this.DB * (this.t - 1) + nbits(this[this.t - 1] ^ (this.s & this.DM))
}

function bnpDLShiftTo(n, r) {
	var i;
	for (i = this.t - 1; i >= 0; --i) {
		r[i + n] = this[i]
	}
	for (i = n - 1; i >= 0; --i) {
		r[i] = 0
	}
	r.t = this.t + n;
	r.s = this.s
}

function bnpDRShiftTo(n, r) {
	for (var i = n; i < this.t; ++i) {
		r[i - n] = this[i]
	}
	r.t = Math.max(this.t - n, 0);
	r.s = this.s
}

function bnpLShiftTo(n, r) {
	var bs = n % this.DB;
	var cbs = this.DB - bs;
	var bm = (1 << cbs) - 1;
	var ds = Math.floor(n / this.DB),
		c = (this.s << bs) & this.DM,
		i;
	for (i = this.t - 1; i >= 0; --i) {
		r[i + ds + 1] = (this[i] >> cbs) | c;
		c = (this[i] & bm) << bs
	}
	for (i = ds - 1; i >= 0; --i) {
		r[i] = 0
	}
	r[ds] = c;
	r.t = this.t + ds + 1;
	r.s = this.s;
	r.clamp()
}

function bnpRShiftTo(n, r) {
	r.s = this.s;
	var ds = Math.floor(n / this.DB);
	if (ds >= this.t) {
		r.t = 0;
		return
	}
	var bs = n % this.DB;
	var cbs = this.DB - bs;
	var bm = (1 << bs) - 1;
	r[0] = this[ds] >> bs;
	for (var i = ds + 1; i < this.t; ++i) {
		r[i - ds - 1] |= (this[i] & bm) << cbs;
		r[i - ds] = this[i] >> bs
	}
	if (bs > 0) {
		r[this.t - ds - 1] |= (this.s & bm) << cbs
	}
	r.t = this.t - ds;
	r.clamp()
}

function bnpSubTo(a, r) {
	var i = 0,
		c = 0,
		m = Math.min(a.t, this.t);
	while (i < m) {
		c += this[i] - a[i];
		r[i++] = c & this.DM;
		c >>= this.DB
	}
	if (a.t < this.t) {
		c -= a.s;
		while (i < this.t) {
			c += this[i];
			r[i++] = c & this.DM;
			c >>= this.DB
		}
		c += this.s
	} else {
		c += this.s;
		while (i < a.t) {
			c -= a[i];
			r[i++] = c & this.DM;
			c >>= this.DB
		}
		c -= a.s
	}
	r.s = (c < 0) ? -1 : 0;
	if (c < -1) {
		r[i++] = this.DV + c
	} else {
		if (c > 0) {
			r[i++] = c
		}
	}
	r.t = i;
	r.clamp()
}

function bnpMultiplyTo(a, r) {
	var x = this.abs(),
		y = a.abs();
	var i = x.t;
	r.t = i + y.t;
	while (--i >= 0) {
		r[i] = 0
	}
	for (i = 0; i < y.t; ++i) {
		r[i + x.t] = x.am(0, y[i], r, i, 0, x.t)
	}
	r.s = 0;
	r.clamp();
	if (this.s != a.s) {
		BigInteger.ZERO.subTo(r, r)
	}
}

function bnpSquareTo(r) {
	var x = this.abs();
	var i = r.t = 2 * x.t;
	while (--i >= 0) {
		r[i] = 0
	}
	for (i = 0; i < x.t - 1; ++i) {
		var c = x.am(i, x[i], r, 2 * i, 0, 1);
		if ((r[i + x.t] += x.am(i + 1, 2 * x[i], r, 2 * i + 1, c, x.t - i - 1)) >= x.DV) {
			r[i + x.t] -= x.DV;
			r[i + x.t + 1] = 1
		}
	}
	if (r.t > 0) {
		r[r.t - 1] += x.am(i, x[i], r, 2 * i, 0, 1)
	}
	r.s = 0;
	r.clamp()
}

function bnpDivRemTo(m, q, r) {
	var pm = m.abs();
	if (pm.t <= 0) {
		return
	}
	var pt = this.abs();
	if (pt.t < pm.t) {
		if (q != null) {
			q.fromInt(0)
		}
		if (r != null) {
			this.copyTo(r)
		}
		return
	}
	if (r == null) {
		r = nbi()
	}
	var y = nbi(),
		ts = this.s,
		ms = m.s;
	var nsh = this.DB - nbits(pm[pm.t - 1]);
	if (nsh > 0) {
		pm.lShiftTo(nsh, y);
		pt.lShiftTo(nsh, r)
	} else {
		pm.copyTo(y);
		pt.copyTo(r)
	}
	var ys = y.t;
	var y0 = y[ys - 1];
	if (y0 == 0) {
		return
	}
	var yt = y0 * (1 << this.F1) + ((ys > 1) ? y[ys - 2] >> this.F2 : 0);
	var d1 = this.FV / yt,
		d2 = (1 << this.F1) / yt,
		e = 1 << this.F2;
	var i = r.t,
		j = i - ys,
		t = (q == null) ? nbi() : q;
	y.dlShiftTo(j, t);
	if (r.compareTo(t) >= 0) {
		r[r.t++] = 1;
		r.subTo(t, r)
	}
	BigInteger.ONE.dlShiftTo(ys, t);
	t.subTo(y, y);
	while (y.t < ys) {
		y[y.t++] = 0
	}
	while (--j >= 0) {
		var qd = (r[--i] == y0) ? this.DM : Math.floor(r[i] * d1 + (r[i - 1] + e) * d2);
		if ((r[i] += y.am(0, qd, r, j, 0, ys)) < qd) {
			y.dlShiftTo(j, t);
			r.subTo(t, r);
			while (r[i] < --qd) {
				r.subTo(t, r)
			}
		}
	}
	if (q != null) {
		r.drShiftTo(ys, q);
		if (ts != ms) {
			BigInteger.ZERO.subTo(q, q)
		}
	}
	r.t = ys;
	r.clamp();
	if (nsh > 0) {
		r.rShiftTo(nsh, r)
	}
	if (ts < 0) {
		BigInteger.ZERO.subTo(r, r)
	}
}

function bnMod(a) {
	var r = nbi();
	this.abs().divRemTo(a, null, r);
	if (this.s < 0 && r.compareTo(BigInteger.ZERO) > 0) {
		a.subTo(r, r)
	}
	return r
}

function Classic(m) {
	this.m = m
}

function cConvert(x) {
	if (x.s < 0 || x.compareTo(this.m) >= 0) {
		return x.mod(this.m)
	} else {
		return x
	}
}

function cRevert(x) {
	return x
}

function cReduce(x) {
	x.divRemTo(this.m, null, x)
}

function cMulTo(x, y, r) {
	x.multiplyTo(y, r);
	this.reduce(r)
}

function cSqrTo(x, r) {
	x.squareTo(r);
	this.reduce(r)
}
Classic.prototype.convert = cConvert;
Classic.prototype.revert = cRevert;
Classic.prototype.reduce = cReduce;
Classic.prototype.mulTo = cMulTo;
Classic.prototype.sqrTo = cSqrTo;

function bnpInvDigit() {
	if (this.t < 1) {
		return 0
	}
	var x = this[0];
	if ((x & 1) == 0) {
		return 0
	}
	var y = x & 3;
	y = (y * (2 - (x & 15) * y)) & 15;
	y = (y * (2 - (x & 255) * y)) & 255;
	y = (y * (2 - (((x & 65535) * y) & 65535))) & 65535;
	y = (y * (2 - x * y % this.DV)) % this.DV;
	return (y > 0) ? this.DV - y : -y
}

function Montgomery(m) {
	this.m = m;
	this.mp = m.invDigit();
	this.mpl = this.mp & 32767;
	this.mph = this.mp >> 15;
	this.um = (1 << (m.DB - 15)) - 1;
	this.mt2 = 2 * m.t
}

function montConvert(x) {
	var r = nbi();
	x.abs().dlShiftTo(this.m.t, r);
	r.divRemTo(this.m, null, r);
	if (x.s < 0 && r.compareTo(BigInteger.ZERO) > 0) {
		this.m.subTo(r, r)
	}
	return r
}

function montRevert(x) {
	var r = nbi();
	x.copyTo(r);
	this.reduce(r);
	return r
}

function montReduce(x) {
	while (x.t <= this.mt2) {
		x[x.t++] = 0
	}
	for (var i = 0; i < this.m.t; ++i) {
		var j = x[i] & 32767;
		var u0 = (j * this.mpl + (((j * this.mph + (x[i] >> 15) * this.mpl) & this.um) << 15)) & x.DM;
		j = i + this.m.t;
		x[j] += this.m.am(0, u0, x, i, 0, this.m.t);
		while (x[j] >= x.DV) {
			x[j] -= x.DV;
			x[++j] ++
		}
	}
	x.clamp();
	x.drShiftTo(this.m.t, x);
	if (x.compareTo(this.m) >= 0) {
		x.subTo(this.m, x)
	}
}

function montSqrTo(x, r) {
	x.squareTo(r);
	this.reduce(r)
}

function montMulTo(x, y, r) {
	x.multiplyTo(y, r);
	this.reduce(r)
}
Montgomery.prototype.convert = montConvert;
Montgomery.prototype.revert = montRevert;
Montgomery.prototype.reduce = montReduce;
Montgomery.prototype.mulTo = montMulTo;
Montgomery.prototype.sqrTo = montSqrTo;

function bnpIsEven() {
	return ((this.t > 0) ? (this[0] & 1) : this.s) == 0
}

function bnpExp(e, z) {
	if (e > 4294967295 || e < 1) {
		return BigInteger.ONE
	}
	var r = nbi(),
		r2 = nbi(),
		g = z.convert(this),
		i = nbits(e) - 1;
	g.copyTo(r);
	while (--i >= 0) {
		z.sqrTo(r, r2);
		if ((e & (1 << i)) > 0) {
			z.mulTo(r2, g, r)
		} else {
			var t = r;
			r = r2;
			r2 = t
		}
	}
	return z.revert(r)
}

function bnModPowInt(e, m) {
	var z;
	if (e < 256 || m.isEven()) {
		z = new Classic(m)
	} else {
		z = new Montgomery(m)
	}
	return this.exp(e, z)
}
BigInteger.prototype.copyTo = bnpCopyTo;
BigInteger.prototype.fromInt = bnpFromInt;
BigInteger.prototype.fromString = bnpFromString;
BigInteger.prototype.clamp = bnpClamp;
BigInteger.prototype.dlShiftTo = bnpDLShiftTo;
BigInteger.prototype.drShiftTo = bnpDRShiftTo;
BigInteger.prototype.lShiftTo = bnpLShiftTo;
BigInteger.prototype.rShiftTo = bnpRShiftTo;
BigInteger.prototype.subTo = bnpSubTo;
BigInteger.prototype.multiplyTo = bnpMultiplyTo;
BigInteger.prototype.squareTo = bnpSquareTo;
BigInteger.prototype.divRemTo = bnpDivRemTo;
BigInteger.prototype.invDigit = bnpInvDigit;
BigInteger.prototype.isEven = bnpIsEven;
BigInteger.prototype.exp = bnpExp;
BigInteger.prototype.toString = bnToString;
BigInteger.prototype.negate = bnNegate;
BigInteger.prototype.abs = bnAbs;
BigInteger.prototype.compareTo = bnCompareTo;
BigInteger.prototype.bitLength = bnBitLength;
BigInteger.prototype.mod = bnMod;
BigInteger.prototype.modPowInt = bnModPowInt;
BigInteger.ZERO = nbv(0);
BigInteger.ONE = nbv(1);

function Arcfour() {
	this.i = 0;
	this.j = 0;
	this.S = new Array()
}

function ARC4init(key) {
	var i, j, t;
	for (i = 0; i < 256; ++i) {
		this.S[i] = i
	}
	j = 0;
	for (i = 0; i < 256; ++i) {
		j = (j + this.S[i] + key[i % key.length]) & 255;
		t = this.S[i];
		this.S[i] = this.S[j];
		this.S[j] = t
	}
	this.i = 0;
	this.j = 0
}

function ARC4next() {
	var t;
	this.i = (this.i + 1) & 255;
	this.j = (this.j + this.S[this.i]) & 255;
	t = this.S[this.i];
	this.S[this.i] = this.S[this.j];
	this.S[this.j] = t;
	return this.S[(t + this.S[this.i]) & 255]
}
Arcfour.prototype.init = ARC4init;
Arcfour.prototype.next = ARC4next;

function prng_newstate() {
	return new Arcfour()
}
var rng_psize = 256;
var rng_state;
var rng_pool;
var rng_pptr;

function rng_seed_int(x) {
	rng_pool[rng_pptr++] ^= x & 255;
	rng_pool[rng_pptr++] ^= (x >> 8) & 255;
	rng_pool[rng_pptr++] ^= (x >> 16) & 255;
	rng_pool[rng_pptr++] ^= (x >> 24) & 255;
	if (rng_pptr >= rng_psize) {
		rng_pptr -= rng_psize
	}
}

function rng_seed_time() {
	rng_seed_int(new Date().getTime())
}
if (rng_pool == null) {
	rng_pool = new Array();
	rng_pptr = 0;
	var t;
	if (window.crypto && window.crypto.getRandomValues) {
		var ua = new Uint8Array(32);
		window.crypto.getRandomValues(ua);
		for (t = 0; t < 32; ++t) {
			rng_pool[rng_pptr++] = ua[t]
		}
	}
	if (navigator.appName == "Netscape" && navigator.appVersion < "5" && window.crypto) {
		var z = window.crypto.random(32);
		for (t = 0; t < z.length; ++t) {
			rng_pool[rng_pptr++] = z.charCodeAt(t) & 255
		}
	}
	while (rng_pptr < rng_psize) {
		t = Math.floor(65536 * Math.random());
		rng_pool[rng_pptr++] = t >>> 8;
		rng_pool[rng_pptr++] = t & 255
	}
	rng_pptr = 0;
	rng_seed_time()
}

function rng_get_byte() {
	if (rng_state == null) {
		rng_seed_time();
		rng_state = prng_newstate();
		rng_state.init(rng_pool);
		for (rng_pptr = 0; rng_pptr < rng_pool.length; ++rng_pptr) {
			rng_pool[rng_pptr] = 0
		}
		rng_pptr = 0
	}
	return rng_state.next()
}

function rng_get_bytes(ba) {
	var i;
	for (i = 0; i < ba.length; ++i) {
		ba[i] = rng_get_byte()
	}
}

function SecureRandom() {}
SecureRandom.prototype.nextBytes = rng_get_bytes;

function parseBigInt(str, r) {
	return new BigInteger(str, r)
}

function linebrk(s, n) {
	var ret = "";
	var i = 0;
	while (i + n < s.length) {
		ret += s.substring(i, i + n) + "\n";
		i += n
	}
	return ret + s.substring(i, s.length)
}

function byte2Hex(b) {
	if (b < 16) {
		return "0" + b.toString(16)
	} else {
		return b.toString(16)
	}
}

function pkcs1pad2(s, n) {
	if (n < s.length + 11) {
		alert("Message too long for RSA");
		return null
	}
	var ba = new Array();
	var i = s.length - 1;
	while (i >= 0 && n > 0) {
		var c = s.charCodeAt(i--);
		if (c < 128) {
			ba[--n] = c
		} else {
			if ((c > 127) && (c < 2048)) {
				ba[--n] = (c & 63) | 128;
				ba[--n] = (c >> 6) | 192
			} else {
				ba[--n] = (c & 63) | 128;
				ba[--n] = ((c >> 6) & 63) | 128;
				ba[--n] = (c >> 12) | 224
			}
		}
	}
	ba[--n] = 0;
	var rng = new SecureRandom();
	var x = new Array();
	while (n > 2) {
		x[0] = 0;
		while (x[0] == 0) {
			rng.nextBytes(x)
		}
		ba[--n] = x[0]
	}
	ba[--n] = 0;
	ba[--n] = 0;
	return new BigInteger(ba)
}

function pkcs1pad3(s, n) {
	if (n < s.length + 11) {
		alert("Message too long for RSA");
		return null
	}
	var ba = new Array();
	var i = 0;
	var j = 0;
	var len = s.length;
	while (i < len && j < n) {
		var c = s.charCodeAt(i++);
		if (c < 128) {
			ba[j++] = c
		} else {
			if ((c > 127) && (c < 2048)) {
				ba[j++] = (c >> 6) | 192;
				ba[j++] = (c & 63) | 128
			} else {
				ba[j++] = (c >> 12) | 224;
				ba[j++] = ((c >> 6) & 63) | 128;
				ba[j++] = (c & 63) | 128
			}
		}
	}
	ba[j++] = 0;
	var rng = new SecureRandom();
	var x = new Array();
	while (j < n) {
		x[0] = 0;
		while (x[0] == 0) {
			rng.nextBytes(x)
		}
		ba[j++] = x[0]
	}
	return new BigInteger(ba)
}

function RSAKey() {
	this.n = null;
	this.e = 0;
	this.d = null;
	this.p = null;
	this.q = null;
	this.dmp1 = null;
	this.dmq1 = null;
	this.coeff = null
}

function RSASetPublic(N, E) {
	if (N != null && E != null && N.length > 0 && E.length > 0) {
		this.n = parseBigInt(N, 16);
		this.e = parseInt(E, 16)
	} else {
		alert("Invalid RSA public key")
	}
}

function RSADoPublic(x) {
	return x.modPowInt(this.e, this.n)
}

function RSAEncrypt(text) {
	var m = pkcs1pad3(text, (this.n.bitLength() + 7) >> 3);
	if (m == null) {
		return null
	}
	var c = this.doPublic(m);
	if (c == null) {
		return null
	}
	var h = c.toString(16);
	if ((h.length & 1) == 0) {
		return h
	} else {
		return "0" + h
	}
}
RSAKey.prototype.doPublic = RSADoPublic;
RSAKey.prototype.setPublic = RSASetPublic;
RSAKey.prototype.encrypt = RSAEncrypt;

/*
 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
 * in FIPS PUB 180-1
 * Version 2.1a Copyright Paul Johnston 2000 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for details.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0; /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad = ""; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz = 8; /* bits per input character. 8 - ASCII; 16 - Unicode      */

/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */
function hex_sha1(s) {
	return binb2hex(core_sha1(str2binb(s), s.length * chrsz));
}

function b64_sha1(s) {
	return binb2b64(core_sha1(str2binb(s), s.length * chrsz));
}

function str_sha1(s) {
	return binb2str(core_sha1(str2binb(s), s.length * chrsz));
}

function hex_hmac_sha1(key, data) {
	return binb2hex(core_hmac_sha1(key, data));
}

function b64_hmac_sha1(key, data) {
	return binb2b64(core_hmac_sha1(key, data));
}

function str_hmac_sha1(key, data) {
	return binb2str(core_hmac_sha1(key, data));
}

/*
 * Perform a simple self-test to see if the VM is working
 */
function sha1_vm_test() {
	return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
}

/*
 * Calculate the SHA-1 of an array of big-endian words, and a bit length
 */
function core_sha1(x, len) {
	/* append padding */
	x[len >> 5] |= 0x80 << (24 - len % 32);
	x[((len + 64 >> 9) << 4) + 15] = len;

	var w = Array(80);
	var a = 1732584193;
	var b = -271733879;
	var c = -1732584194;
	var d = 271733878;
	var e = -1009589776;

	for (var i = 0; i < x.length; i += 16) {
		var olda = a;
		var oldb = b;
		var oldc = c;
		var oldd = d;
		var olde = e;

		for (var j = 0; j < 80; j++) {
			if (j < 16) w[j] = x[i + j];
			else w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
			var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
				safe_add(safe_add(e, w[j]), sha1_kt(j)));
			e = d;
			d = c;
			c = rol(b, 30);
			b = a;
			a = t;
		}

		a = safe_add(a, olda);
		b = safe_add(b, oldb);
		c = safe_add(c, oldc);
		d = safe_add(d, oldd);
		e = safe_add(e, olde);
	}
	return Array(a, b, c, d, e);

}

/*
 * Perform the appropriate triplet combination function for the current
 * iteration
 */
function sha1_ft(t, b, c, d) {
	if (t < 20) return (b & c) | ((~b) & d);
	if (t < 40) return b ^ c ^ d;
	if (t < 60) return (b & c) | (b & d) | (c & d);
	return b ^ c ^ d;
}

/*
 * Determine the appropriate additive constant for the current iteration
 */
function sha1_kt(t) {
	return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 :
		(t < 60) ? -1894007588 : -899497514;
}

/*
 * Calculate the HMAC-SHA1 of a key and some data
 */
function core_hmac_sha1(key, data) {
	var bkey = str2binb(key);
	if (bkey.length > 16) bkey = core_sha1(bkey, key.length * chrsz);

	var ipad = Array(16),
		opad = Array(16);
	for (var i = 0; i < 16; i++) {
		ipad[i] = bkey[i] ^ 0x36363636;
		opad[i] = bkey[i] ^ 0x5C5C5C5C;
	}

	var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
	return core_sha1(opad.concat(hash), 512 + 160);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y) {
	var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function rol(num, cnt) {
	return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert an 8-bit or 16-bit string to an array of big-endian words
 * In 8-bit function, characters >255 have their hi-byte silently ignored.
 */
function str2binb(str) {
	var bin = Array();
	var mask = (1 << chrsz) - 1;
	for (var i = 0; i < str.length * chrsz; i += chrsz)
		bin[i >> 5] |= (str.charCodeAt(i / chrsz) & mask) << (32 - chrsz - i % 32);
	return bin;
}

/*
 * Convert an array of big-endian words to a string
 */
function binb2str(bin) {
	var str = "";
	var mask = (1 << chrsz) - 1;
	for (var i = 0; i < bin.length * 32; i += chrsz)
		str += String.fromCharCode((bin[i >> 5] >>> (32 - chrsz - i % 32)) & mask);
	return str;
}

/*
 * Convert an array of big-endian words to a hex string.
 */
function binb2hex(binarray) {
	var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
	var str = "";
	for (var i = 0; i < binarray.length * 4; i++) {
		str += hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8 + 4)) & 0xF) +
			hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8)) & 0xF);
	}
	return str;
}

/*
 * Convert an array of big-endian words to a base-64 string
 */
function binb2b64(binarray) {
	var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	var str = "";
	for (var i = 0; i < binarray.length * 4; i += 3) {
		var triplet = (((binarray[i >> 2] >> 8 * (3 - i % 4)) & 0xFF) << 16) | (((binarray[i + 1 >> 2] >> 8 * (3 - (i + 1) % 4)) & 0xFF) << 8) | ((binarray[i + 2 >> 2] >> 8 * (3 - (i + 2) % 4)) & 0xFF);
		for (var j = 0; j < 4; j++) {
			if (i * 8 + j * 6 > binarray.length * 32) str += b64pad;
			else str += tab.charAt((triplet >> 6 * (3 - j)) & 0x3F);
		}
	}
	return str;
}