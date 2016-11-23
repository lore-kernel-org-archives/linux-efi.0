From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime
 services [ver #2]
Date: Wed, 23 Nov 2016 13:38:55 +0000
Message-ID: <20161123133855.GG24624@leverpostej>
References: <20161123102747.GD24624@leverpostej>
 <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
 <6125.1479901598@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6125.1479901598-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 11:46:38AM +0000, David Howells wrote:
> Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Wed, Nov 23, 2016 at 12:22:43AM +0000, David Howells wrote:
> > > Provide the ability to perform mixed-mode runtime service calls for arm in
> > > the same way that commit 0a637ee61247bd4bed9b2a07568ef7a1cfc76187
> > > ("x86/efi: Allow invocation of arbitrary boot services") provides the
> > > ability to invoke arbitrary boot services.
> > 
> > I'm not sure I understand. On arm/arm64, "mixed-mode" simply isn't possible.
> > 
> > I see we already call runtime services directly in efi_get_secureboot()
> > in drivers/firmware/efi/libstub/arm-stub.c.
> > 
> > If this is just to provide a consistent API for the stub, please note
> > that.
> 
> How about:
> 
>     arm/efi: Allow invocation of arbitrary runtime services
>     
>     efi_call_runtime() is provided for x86 to be able abstract mixed mode
>     support.  Provide this for ARM also so that common code work in mixed mode
>     also.

That sounds good to me.

Thanks,
Mark.
