From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
Date: Tue, 6 Nov 2012 10:30:26 +0800
Message-ID: <CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <s5hhap49den.wl%tiwai@suse.de>
Sender: linux-security-module-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 6, 2012 at 1:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> To be noted, it doesn't support the firmwares via udev but only the
> direct loading, and the check for built-in firmware is missing, too.

Generally, both direct loading and udev may request one same firmware
image. And after check failed, current firmware load will fallback on udev
to complete loading, so looks a check-failed firmware still can be loaded
into kernel no matter if there is firmware signature check or not.


Thanks,
--
Ming Lei
