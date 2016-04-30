From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Sat, 30 Apr 2016 23:35:14 +0100
Message-ID: <20160430223514.GP2839@codeblueprint.co.uk>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
 <5720BE0B.8080605@moshe.nl>
 <CA+5PVA71vCaf+a=6cEqQxe4iUQeAK5NN-s09bMDa6_NbXZfMNw@mail.gmail.com>
 <5720D365.5080601@moshe.nl>
 <CA+5PVA51UZL3zkYgLAimnXcYQwNJ4h+zCqEt0XRp2UEHaV302g@mail.gmail.com>
 <20160427170525.GA1965@jtriplet-mobl2.jf.intel.com>
 <CA+5PVA7bsX9UTM6DCnhE0gHDumGTZgKDGNAgd-teCG8YCM5Nsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA7bsX9UTM6DCnhE0gHDumGTZgKDGNAgd-teCG8YCM5Nsg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Adding Colin and Ricardo)

On Wed, 27 Apr, at 01:23:55PM, Josh Boyer wrote:
> 
> How is an end user supposed to see such a message and report it to the
> people that can fix it?  They can't.  So they report it in their
> distributions bug tracker and it either gets closed as "yeah, firmware
> sucks" or it sits there and rots in the hope that some day someone
> will do something.
> 
> I understand where you're coming from in a pre-production, development
> environment but to be quite clear that is not the default environment
> Linux is run in most of the time.  If this were a kernel warning, that
> could be fixed with a kernel patch, then maybe it would be worth it.
> It isn't though.

If the error messages in the BGRT driver make it impossible for end
users to achieve a pretty boot experience then I agree, that is a
kernel bug. BGRT is an exception to the usual rule about complaining
loudly when we encounter firmware bugs simply because we're dealing
with UIs in this case.

That's not to say we should give up reporting these kinds of invalid
table issues to firmware developers altogether. There are other means
of doing it, and comprising the wants of many end users for the
benefit of few firmware developers (relatively) is just not sensible.

Colin, Ricardo, I haven't checked recently, are there ACPI BGRT
validations tests in FWTS and LUV? Josh (Triplett), BITS would seem
like a very good place to include these tests since it already has a
bunch of ACPI table checks.
