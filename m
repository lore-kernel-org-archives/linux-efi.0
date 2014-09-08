From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Mon, 8 Sep 2014 16:58:55 +0100
Message-ID: <20140908155855.GS3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140905221616.GP3001@console-pimps.org>
 <CAPWNY8V6Vw0JBZ=VE_ZLZ1hiKVhrDbYyWfkLXMQtKYHZjmewRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPWNY8V6Vw0JBZ=VE_ZLZ1hiKVhrDbYyWfkLXMQtKYHZjmewRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 06 Sep, at 11:09:04PM, Mantas Mikul=C4=97nas wrote:
>=20
> Finally got around to testing the patches here. Sorry for no replies =
earlier.
>=20
> This seemed like it would work, but... it hangs at the memcpy?...
>=20
> (If I add a printk before memcpy and a printk after memcpy, I never
> see the second one. I guess that memory location is just cursed, or
> something.)
=20
Thanks for testing. Let's go ahead with Yinghai's patch ("x86/efi: Only
load initrd above 4g on second try").

--=20
Matt Fleming, Intel Open Source Technology Center
