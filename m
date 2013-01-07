From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] Fix efifb initialisation when the only GOP device
 implements ConOut.
Date: Mon, 7 Jan 2013 18:43:20 +0000
Message-ID: <20130107184320.GA1400@srcf.ucam.org>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
 <1357524250.9270.86.camel@shinybook.infradead.org>
 <1357578923.8203.72.camel@mfleming-mobl1.ger.corp.intel.com>
 <1357581080.2844.17.camel@shinybook.infradead.org>
 <20130107175846.GA385@srcf.ucam.org>
 <1357583795.2844.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1357583795.2844.18.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 07, 2013 at 06:36:35PM +0000, David Woodhouse wrote:
> On Mon, 2013-01-07 at 17:58 +0000, Matthew Garrett wrote:
> > Ignore this case? You can't run 32-bit kernels on 64-bit EFI, or=20
> > vice-versa. You'll die on the first call to UEFI services.
>=20
> The kernel has code to avoid calling UEFI services in that case. Even=
 if
> we don't want to support that (any more?), we should at least fail
> gracefully rather than just jumping to the wrong entry point and havi=
ng
> RandomShit=E2=84=A2 happening.

The kernel does, the EFI boot stub doesn't. There's probably an argumen=
t=20
for having it fail in that case, but it wouldn't even be able to print=20
an error message without some gymnastics.

--=20
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
