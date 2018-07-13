From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Fri, 13 Jul 2018 10:16:36 +0000
Message-ID: <1e19dbef068b45a4a4e9eb4072e097be@AcuMS.aculab.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
	<20180621162324.36656-4-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3298164636862127187=="
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180621162324.36656-4-ndesaulniers@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: 'Nick Desaulniers' <ndesaulniers@google.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "andrea.parri@amarulasolutions.com" <andrea.parri@amarulasolutions.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "brijesh.singh@amd.com" <brijesh.singh@amd.com>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>, "manojgupta@google.com" <manojgupta@google.com>, "hpa@zytor.com" <hpa@zytor.com>, "akataria@vmware.com" <akataria@vmware.com>, "tweek@google.com" <tweek@google.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, ghackmann@google.com
List-Id: linux-efi@vger.kernel.org

--===============3298164636862127187==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="MCBoundary=_11807131115062971"

--MCBoundary=_11807131115062971
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

UmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1p
bHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVz
KQ0KDQpQbGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGFuZCBkb24ndCBwcmludCB0aGlz
IGUtbWFpbCB1bmxlc3MgeW91IHJlYWxseSBuZWVkIHRvDQo=
--MCBoundary=_11807131115062971
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<html><body>From: Nick Desaulniers<BR>
&gt; Sent: 21 June 2018 17:23<BR>
&gt; <BR>
&gt; native_save_fl() is marked static inline, but by using it as<BR>
&gt; a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.=
<BR>
&gt; <BR>
&gt; paravirt's use of native_save_fl() also requires that no GPRs other th=
an<BR>
&gt; %rax are clobbered.<BR>
...<BR>
&gt; diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/ir=
qflags.h<BR>
&gt; index 89f08955fff7..c4fc17220df9 100644<BR>
&gt; --- a/arch/x86/include/asm/irqflags.h<BR>
&gt; +++ b/arch/x86/include/asm/irqflags.h<BR>
&gt; @@ -13,7 +13,7 @@<BR>
&gt;   * Interrupt control:<BR>
&gt;   */<BR>
&gt; <BR>
&gt; -static inline unsigned long native_save_fl(void)<BR>
&gt; +extern inline unsigned long native_save_fl(void)<BR>
<BR>
This is generating a the compilation warning (that we treat as an error):<B=
R>
&quot;no previous prototype for 'native_save_fl&quot;.<BR>
Fixable by replicating the line with an appended ;<BR>
<BR>
=09David<BR>

<br /><br /><br /><div><span style=3D"color:#484830;font-family:Tahoma;font=
-size:xx-small">Registered Address Lakeside, Bramley Road, Mount Farm, Milt=
on Keynes, MK1 1PT, UK<br />Registration No: 1397386 (Wales)</span></div>
<div>
<p><span style=3D"color:#008000;font-family:Arial"><span style=3D"font-size=
:xx-small"><span style=3D"font-family:Webdings">P </span><strong>Please con=
sider the environment and don't print this e-mail unless you really need to=
</strong></span></span></p>
</div></body></html>

--MCBoundary=_11807131115062971--


--===============3298164636862127187==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============3298164636862127187==--
