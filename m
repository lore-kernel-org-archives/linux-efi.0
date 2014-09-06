From: Andre <andre.muller-S0/GAf8tV78@public.gmane.org>
Subject: Re: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Sat, 6 Sep 2014 23:02:51 +0200
Message-ID: <20140906230251.140a99c9@bert>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@...> writes:
>=20
> On Thu, 10 Jul, at 02:12:41AM, ulf@... wrote:
> >  <at>  <at>  -1376,7 +1376,10  <at>  <at>  struct boot_params *efi_=
main(struct efi_config *c,
> >=20
> >     setup_graphics(boot_params);
> >=20
> > -   setup_efi_pci(boot_params);
> > +   status =3D setup_efi_pci(boot_params);
> > +   if (status !=3D EFI_SUCCESS) {
> > +           efi_printk(sys_table, "setup_efi_pci() failed!\n");
> > +   }
>=20
> Actually, it turns out that a lot of people are seeing this error
> message in what would be an otherwise quiet boot,
>=20
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D81891
>=20
> Maybe we should distinguish between EFI_PCI_IO_PROTOCOL_GUID not bein=
g
> found and all other errors, i.e. memory allocation failure. We obviou=
sly
> do want to know if we failed to allocate memory, but we're less bothe=
red
> if we've no PCI devices.
>=20
> Something like below? Folks on Cc, could you apply this snippet and s=
ee
> whether you're still seeing the error message?
>=20

With a Thinkpad T420 (pre-2.0 EFI), I do run into the failure condition=
 for another reason:

setup_efi_pci64 gets called,
the loop therein is executed nr_pci=3D11 (!?) times.
The second call run calls into __setup_efi_pci64 successfully, the memc=
py takes place; the free_struct: path is not used. Back in setup_efi_pc=
i64, the non-data path is walked.

=46or all the other 10 runs of the loop, __setup_efi_pci64 fails at
if (!pci->romimage || !pci->romsize)
        return EFI_INVALID_PARAMETER;
so that is the status here for any run but the second.

So here, I can work around the message by accepting the EFI_INVALID_PAR=
AMETER condition.=20
Also, I can work around that by adding break; to the end of the loop in=
 setup_efi_pci64, as it only gets to the end in the successful case. Bu=
t I guess other machines require to loop successfully through this more=
 than once?

Regards,
Andre M=FCller
