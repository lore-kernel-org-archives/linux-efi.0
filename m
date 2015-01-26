From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: Boot with EFI stub fails on VMWare during decompression
Date: Mon, 26 Jan 2015 11:23:25 +0000
Message-ID: <20150126112325.GC3320@codeblueprint.co.uk>
References: <20150116110344.715cc887@pluto.restena.lu>
 <20150120190238.GB12079@codeblueprint.co.uk>
 <20150121145420.76511d61@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150121145420.76511d61-I2t2yFIzmohO7ya8xxV06g@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Jan, at 02:54:20PM, Bruno Pr=E9mont wrote:
>=20
> So the default LOAD_PHYSICAL_ADDR is being selected/used.
>=20
> This all happens after efi_main() as far as I can understand.
> Is there a way to let efi_printk() do string formatting? It should ha=
ve
> both source and destination addresses as it is doing the relocation (=
or at
> least one step of it).

"Here's one I made earlier..."

Take a look at the patches on the 'efi-debug' branch, they may be
useful,

http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=3De=
fi-debug

--=20
Matt Fleming, Intel Open Source Technology Center
