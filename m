From: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] fix double ;;s in code
Date: Thu, 22 Feb 2018 17:09:33 +0800
Message-ID: <20180222090932.GJ3217@dragon>
References: <20180217211955.GE9640@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180217211955.GE9640@amd>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Alexey.Brodkin-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, fbarrat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, paulus-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, JinHuiEric.Huang-5C7GfCeVMHo@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, scott.bauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, David1.Zhou-5C7GfCeVMHo@public.gmane.org, architt-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wenjing.Liu-5C7GfCeVMHo@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ding.Wang-5C7GfCeVMHo@public.gmane.org, aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, wens-jdAy2FN1RRM@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ruscur-3Su/lFKaw5ejKv3TNrM5DQ@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.orga
List-Id: linux-efi@vger.kernel.org

SGkgUGF2ZWwsCgpPbiBTYXQsIEZlYiAxNywgMjAxOCBhdCAxMDoxOTo1NVBNICswMTAwLCBQYXZl
bCBNYWNoZWsgd3JvdGU6Ci4uLgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NvYy9pbXgvZ3BjLmMg
Yi9kcml2ZXJzL3NvYy9pbXgvZ3BjLmMKPiBpbmRleCA1M2Y3Mjc1Li5jZmI0MmY1IDEwMDY0NAo+
IC0tLSBhL2RyaXZlcnMvc29jL2lteC9ncGMuYwo+ICsrKyBiL2RyaXZlcnMvc29jL2lteC9ncGMu
Ywo+IEBAIC0zNDgsNyArMzQ4LDcgQEAgc3RhdGljIGludCBpbXhfZ3BjX29sZF9kdF9pbml0KHN0
cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IHJlZ21hcCAqcmVnbWFwLAo+ICAJCWlmIChpID09IDEp
IHsKPiAgCQkJZG9tYWluLT5zdXBwbHkgPSBkZXZtX3JlZ3VsYXRvcl9nZXQoZGV2LCAicHUiKTsK
PiAgCQkJaWYgKElTX0VSUihkb21haW4tPnN1cHBseSkpCj4gLQkJCQlyZXR1cm4gUFRSX0VSUihk
b21haW4tPnN1cHBseSk7Owo+ICsJCQkJcmV0dXJuIFBUUl9FUlIoZG9tYWluLT5zdXBwbHkpOwo+
ICAKPiAgCQkJcmV0ID0gaW14X3BnY19nZXRfY2xvY2tzKGRldiwgZG9tYWluKTsKPiAgCQkJaWYg
KHJldCkKPiAKCkNvbnNpZGVyaW5nIHRoZSBjb250cm92ZXJzeSBob3cgdGhlIGNoYW5nZXMgc2hv
dWxkIGJlIG1lcmdlZCwgSSdtIGdvaW5nCnRvIHNlbmQgYSBzZXBhcmF0ZSBwYXRjaCBqdXN0IGZv
ciBJTVggR1BDIGRyaXZlciB3aXRoIGEgcmVwb3J0ZWQtYnkteW91CnRhZy4gIFRoYW5rcyBmb3Ig
Y2F0Y2hpbmcgdGhpcy4KClNoYXduCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0
b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1k
LWdmeAo=
