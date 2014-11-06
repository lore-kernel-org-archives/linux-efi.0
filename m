From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Thu, 6 Nov 2014 12:53:54 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80F3A9@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com>
 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com>
 <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, Sam Protsenko <semen.protsenko@linaro.org>, LKML <linux-kernel@vger.kernel.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21h
aWx0bzpsdXRvQGFtYWNhcGl0YWwubmV0XQ0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDA1
LCAyMDE0IDEyOjM2IEFNDQo+IA0KPiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nIGhlcmU/ICBUaGUg
Y3VycmVudCBwcm9wb3NhbCBpcyBtaXNzaW5nIHRoZQ0KPiBzdWNjZXNzL2ZhaWx1cmUgcGFydCwg
dW5sZXNzIHlvdSBjb3VudCB0aGUgbG9hZGVkIGNvdW50IChpbiBhIGRpZmZlcmVudCBzeXNmcw0K
PiBkaXJlY3RvcnkpIGFzIGEgdXNlZnVsIGludGVyZmFjZSBmb3IgdGhhdC4NCg0KSGVyZSBpcyBt
eSBzYW1wbGUgc2hlbGwgc2NyaXB0IHdoaWNoIGFsbG93IG1lIHRvIGRvIG11bHRpIGNhcHN1bGUg
YmluYXJpZXMgdXBsb2FkDQphbmQgb2J0YWluIGVycm9yIG1lc3NhZ2UgaWYgZXJyb3Igb2NjdXI6
DQoNCiMhL2Jpbi9zaA0KDQpvbGQ9JChjYXQgL3N5cy9kZXZpY2VzL3BsYXRmb3JtL2VmaV9jYXBz
dWxlX3VzZXJfaGVscGVyL2NhcHN1bGVfbG9hZGVkKQ0KDQpmb3IgYXJnIGluICIkQCINCmRvDQoJ
aWYgWyAtZiAkYXJnIF0NCgl0aGVuDQoJCWVjaG8gMSA+IC9zeXMvY2xhc3MvZmlybXdhcmUvZWZp
LWNhcHN1bGUtZmlsZS9sb2FkaW5nDQoJCWNhdCAkYXJnID4gL3N5cy9jbGFzcy9maXJtd2FyZS9l
ZmktY2Fwc3VsZS1maWxlL2RhdGENCgkJZWNobyAwID4gL3N5cy9jbGFzcy9maXJtd2FyZS9lZmkt
Y2Fwc3VsZS1maWxlL2xvYWRpbmcNCg0KCQlvbGR0aW1lPSQoZGF0ZSArJVMpDQoJCW9sZHRpbWU9
JCgoKHRpbWUgKyAyKSAlIDYwKSkNCgkJdW50aWwgWyAtZiAvc3lzL2NsYXNzL2Zpcm13YXJlL2Vm
aS1jYXBzdWxlLWZpbGUvbG9hZGluZyBdDQoJCWRvDQoJCQluZXd0aW1lPSQoZGF0ZSArJVMpDQoJ
CQlpZiBbICRuZXd0aW1lIC1lcSAkb2xkdGltZSBdDQoJCQl0aGVuDQoJCQkJYnJlYWsNCgkJCWZp
DQoJCWRvbmUNCg0KCQlvbGQ9JCgob2xkICsgMSkpDQoJCW5ldz0kKGNhdCAvc3lzL2RldmljZXMv
cGxhdGZvcm0vZWZpX2NhcHN1bGVfdXNlcl9oZWxwZXIvY2Fwc3VsZV9sb2FkZWQpDQoJCWlmIFsg
ISAkbmV3IC1lcSAkb2xkIF0NCgkJdGhlbg0KCQkJZWNobyAiQ2Fwc3VsZSBiaW5hcnkgJGFyZyB1
cGxvYWQgZmFpbGVkIg0KCQkJZG1lc2cgfCB0YWlsIHwgZ3JlcCAtdiBwbGF0Zm9ybSB8IGdyZXAg
LWUgZWZpDQoJCQlleGl0IDENCgkJZmkNCgllbHNlDQoJCWVjaG8gIkZpbGUgJGFyZyBub3QgZm91
bmQgISEiDQoJZmkNCmRvbmUNCmV4aXQgMA0KDQoNClJlZ2FyZHMsDQpXaWxzb24NCg0K
