From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
Date: Tue, 06 Nov 2012 00:01:52 +0000
Message-ID: <5839.1352160112@warthog.procyon.org.uk>
References: <s5hhap49den.wl%tiwai@suse.de> <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <s5hobjia6vj.wl%tiwai@suse.de> <20121031173728.GA18615@srcf.ucam.org> <s5h390utqv3.wl%tiwai@suse.de> <1351743715.21227.95.camel@linux-s257.site> <20121101131849.752df6fd@pyramind.ukuu.org.uk> <s5hip9k9dng.wl%tiwai@suse.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5hhap49den.wl%tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org> wrote:

> this is a patch series to add the support for firmware signature
> check.  At this time, the kernel checks extra signature file (*.sig)
> for each firmware, instead of embedded signature.
> It's just a quick hack using the existing module signing mechanism,
> thus provided only as a proof of concept for now.

There is another way to do this.  If you look at the patches I proposed to
wrap keys in PE binaries, you'll find that that can handle PKCS#7 format
messages as that's what's in the sort of signed PE binary we're dealing with.

You could use this to put the firmware inside a signed-data PKCS#7 message.

David
