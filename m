From: Matt Fleming <matt@console-pimps.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 10:18:48 +0100
Message-ID: <20140805091848.GN15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
 <20140805084542.GM15082@console-pimps.org>
 <20140805111330.3cf9319f@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140805111330.3cf9319f@pluto>
Sender: linux-kernel-owner@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Aug, at 11:13:30AM, Bruno Pr=E9mont wrote:
>=20
> I get at least to just before
>   status =3D efi_call_early(exit_boot_services, handle, key);
> in eboot.c on line 1310. A efi_printk inserted there is displayed.

This is worth pointing out in case you're unaware, but do you know that
it's not valid to call efi_printk() after ExitBootServices()? Doing so
will almost certainly cause your machine to fault.

--=20
Matt Fleming, Intel Open Source Technology Center
