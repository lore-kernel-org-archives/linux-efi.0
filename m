From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efibc: EFI Bootloader Control
Date: Mon, 25 Apr 2016 13:17:53 +0100
Message-ID: <20160425121753.GT2829@codeblueprint.co.uk>
References: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
 <20160414160006.GR2829@codeblueprint.co.uk>
 <87r3e383v7.fsf@jcompost-MOBL1.tl.intel.com>
 <87mvor83tl.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvor83tl.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Apr, at 03:05:42PM, Jeremy Compostella wrote:
> +static void efibc_set_variable(const char *name, const char *value)
> +{
> +	int ret;
> +	efi_guid_t guid =3D EFI_LOADER_GUID;
> +	struct efivar_entry entry;
> +	size_t size =3D (strlen(value) + 1) * sizeof(efi_char16_t);

Putting 'entry' on the stack leads to the following build warning,

 drivers/firmware/efi/efibc.c: In function =E2=80=98efibc_set_variable=E2=
=80=99:
 drivers/firmware/efi/efibc.c:53:1: warning: the frame size of 2192 byt=
es is larger than 2048 bytes [-Wframe-larger-than=3D]

That's a big object.

Given that efibc_reboot_notifier_call() can only be invoked once,
could we just statically allocate 'entry' instead?
