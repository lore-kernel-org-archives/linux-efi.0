From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 19 Mar 2014 18:42:03 +0100
Message-ID: <87lhw684r8.fsf@mid.deneb.enyo.de>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
	<20140226222151.78854cd8@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140226222151.78854cd8@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 26 Feb 2014 22:21:51 +0000")
Sender: linux-security-module-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Matthew Garrett <matthew.garrett@nebula.com>, LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

* One Thousand Gnomes:

>> For the Chrome OS use-case, it might be better described as "untrusted
>> userspace", but that seems unfriendly. :) The "trusted kernel" name
>> seems fine to me.
>
> Trusted is rather misleading. It's not trusted, it's *measured*.

I don't think anyone is doing any measurement.  In particular, the
kernel does not know anything about the history of the boot process
and cannot provide any form of attestation.  This is why this feature
is not very useful to end users.
