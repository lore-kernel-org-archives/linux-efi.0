From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 13:18:49 +0000
Message-ID: <20121101131849.752df6fd@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351743715.21227.95.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> I think it make sense because the private key is still protected by
> signer. Any hacker who modified firmware is still need use private key
> to generate signature, but hacker's private key is impossible to match
> with the public key that kernel used to verify firmware.
> 
> And, I afraid we have no choice that we need put the firmware signature
> in a separate file. Contacting with those company's legal department
> will be very time-consuming, and I am not sure all company will agree we
> put the signature with firmware then distribute.

Then you'd better stop storing it on disk because your disk drive is FEC
encoding it and adding a CRC 8)

It does want checking with a lawyer but my understanding is that if you
have a file which is a package that contains the firmware and a signature
then there is not generally a problem, any more than putting it in an RPM
file - it's packaging/aggregation. This should be referred to the Linux
Foundation folks perhaps - no point designing something badly to work
around a non existant issue.

Also the interface needs to consider that a lot of device firmware is
already signed. Nobody notices because they don't ever try and do their
own thus many drivers don't need extra signatures in fact.

Alan
