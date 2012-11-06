From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
Date: Tue, 6 Nov 2012 11:15:26 +0000
Message-ID: <20121106111526.2ab6f314@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
	<CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
	<s5h8vafi56z.wl%tiwai@suse.de>
	<CACVXFVPDZnXshvartbTt6gaGzcb+03sVq3Qm3apQQ8AVcQWerg@mail.gmail.com>
	<s5h4nl3i3u6.wl%tiwai@suse.de>
	<CACVXFVPJ0TWf=ffFhw+UGoGgsRnrD7o+Ws5rdDxS52jSf4SZ4A@mail.gmail.com>
	<s5h1ug7i1q5.wl%tiwai@suse.de>
	<CACVXFVOOEf=Ype=2OGjjjgXZWo=5xd8Hhu2CSTaKTtGAybaA=w@mail.gmail.com>
	<s5h4nl39gt9.wl%tiwai@suse.de>
	<CACVXFVOzRxp9owV5O9NFLuL5md04Bmu35oCuNvnVsZAzmHxH=A@mail.gmail.com>
	<s5hy5if80kq.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5hy5if80kq.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> > It is true if all firmwares are signed on safe boot. If firmware is allowed
> > to be loaded from network or other non-fs place in secure distribution,
> > your patch will break this loading.

Actually it's not. It should be true that firmware that can harm machine
integrity and is loaded by the OS is signed at some level. However it is
not true that

- firmware that is no integrity threat (eg USB firmware)
- firmware that can be flash updated on another PC and not observed by
  the target

are necessarily in any way signed or secure.

> Do we already have such a secure mechanism?  How is the security
> assured?

Another thing to consider is that a lot of hardware (particularly
anything aimed at such 'secure boot' machines) is already digitally
signed. Whether you need to enforce external signing is a mix of driver
specific questions ("does this device have signed firmware anyway", "can
bogus firmware do anything interesting") and local policy "do I as admin
want to block any firmware that isn't corporate site approved"

For USB this is quite important because there is a ton of hardware out
there which is intended to have firmware dumped into it for hacking and
fun purposes and should generally be totally outside of the signing
stuff.

Alan
