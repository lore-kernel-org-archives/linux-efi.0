From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Thu, 30 May 2013 10:38:33 +0800
Message-ID: <1369881513.17397.51.camel@linux-s257.site>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130529224645.GA16582-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-05-29 =E6=96=BC 17:46 -0500=EF=BC=8CRu=
ss Anderson =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, May 30, 2013 at 12:22:13AM +0200, Jiri Kosina wrote:
> > On Wed, 29 May 2013, Russ Anderson wrote:
> >=20
> > > > What appears to be happening is that your the EFI runtime servi=
ces code
> > > > is calling into the EFI boot services code, which is definitely=
 a bug in
> > > > your firmware because we're at runtime, but we've seen other ma=
chines
> > > > that do similar things so we usually handle it just fine. Howev=
er, what
> > > > makes your case different, and the reason you see the above spl=
at, is
> > > > that it's using the physical address of the EFI boot services r=
egion,
> > > > not the virtual one we setup with SetVirtualAddressMap(). Which=
 is a
> > > > second firmware bug. Again, we have seen other machines that ac=
cess
> > > > physical addresses after SetVirtualAddressMap(), but until now =
we
> > > > haven't had any non-optional code that triggered them.
> > > >=20
> > > > The only reason I can see that the offending commit would intro=
duce this
> > > > problem is because it calls QueryVariableInfo() at boot time. I=
 notice
> > > > that your machine is an SGI UV one, is there any chance you cou=
ld get a
> > > > firmware fix for this? If possible, it would be also good to co=
nfirm
> > > > that it's this chunk of code in setup_efi_vars(),
> > > >=20
> > > > 	status =3D efi_call_phys4(sys_table->runtime->query_variable_i=
nfo,
> > > > 				EFI_VARIABLE_NON_VOLATILE |
> > > > 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > > > 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> > > > 				&remaining_size, &var_size);
> > >=20
> > > This does trigger the problem.  Note that the definition of
> > > QueryVariableInfo() in the UEFI spec says:
> > >=20
> > >   The returned MaximumVariableStorageSize, RemainingVariableStora=
geSize,
> > >   MaximumVariableSize information may change immediately after th=
e call
> > >   based on other runtime activities including asynchronous error =
events.
> > >   Also, these values associated with different attributes are not
> > >   additive in nature.
> > >=20
> > > Note the values may be accurate at the point in time when returne=
d,
> > > but may not be after that.
> > >=20
> > >   After the system has transitioned into runtime (after
> > >   ExitBootServices() is called), an implementation may not be abl=
e to
> > >   accurately return information about the Boot Services variable =
store.
> > >   In such cases, EFI_INVALID_PARAMETER should be returned.
> > >=20
> > > It is not clear to me exactly when ExitBootServices() is called.
> > > Our bios is returning a failing indication on the call.
> >=20
> > Yes, but this call is clearly happening way before ExitBootServices=
() --=20
> > see the surrounding code, see for example this in efi_main():
> >=20
> > [ ... snip ... ]
> > 	setup_efi_vars(boot_params);
> >=20
> > 	setup_efi_pci(boot_params);
> >=20
> > 	status =3D efi_call_phys3(sys_table->boottime->allocate_pool,
> > 				EFI_LOADER_DATA, sizeof(*gdt),
> > 				(void **)&gdt);
> > 	if (status !=3D EFI_SUCCESS) {
> > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > 		goto fail;
> > 	}
> > [ ... snip ... ]
>=20
> Yes.  Note the failing call is sys_table->runtime while all the
> other calls are sys_table->boottime and seem to work.  Not sure
> why the sys_table->runtime call has a problem but it may be
> a clue.  Could something in the runtime path not be set up???
>=20

Per UEFI spec Section 6, all runtime services should a available both o=
n
boot time and runtime. And, we query the EFI_VARIABLE_BOOTSERVICE_ACCES=
S
space information before ExitBootServices(), that means we call it in
boot time, so, QueryVariableInfo() should return information to us.

Back to the kernel oops, the oops happened in runtime environment when
efivar_init running. As Matt's point out as following:

=E6=96=BC =E4=BA=94=EF=BC=8C2013-05-24 =E6=96=BC 08:43 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A=20
> On Thu, 23 May, at 03:32:34PM, Russ Anderson wrote:
> >    efi: mem127: type=3D4, attr=3D0xf, range=3D[0x000000006bb22000-0=
x000000007ca9c000) (271MB)
>=20
> EFI_BOOT_SERVICES_CODE

Per UEFI 2.3.1 Section 6.2, type 4 is EfiBootServicesCode. This area av=
ailable for
OS using after ExitBootServices():

UEFI 2.3.1 P.133
 EfiBootServicesData Memory available for general use.

So, any runtime services should not access this area, it's the first th=
ing need to check
the BIOS code for why.

> >    efi: mem133: type=3D5, attr=3D0x800000000000000f, range=3D[0x000=
000007daff000-0x000000007dbff000) (1MB)
>=20
> EFI_RUNTIME_SERVICES_CODE
>=20
> >    EFI Variables Facility v0.08 2004-May-17
> >    BUG: unable to handle kernel paging request at 000000007ca95b10
> >    IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
[...]
What appears to be happening is that your the EFI runtime services code
> is calling into the EFI boot services code, which is definitely a bug=
 in
> your firmware because we're at runtime, but we've seen other machines
> that do similar things so we usually handle it just fine. However, wh=
at
> makes your case different, and the reason you see the above splat, is
> that it's using the physical address of the EFI boot services region,
> not the virtual one we setup with SetVirtualAddressMap(). Which is a
> second firmware bug. Again, we have seen other machines that access
> physical addresses after SetVirtualAddressMap(), but until now we
> haven't had any non-optional code that triggered them.

Actually, when efivars doing init, system is already in virtual mode no=
t just runtime
mode, that means OS already call SetVirtualAddressMap() to set the EfiB=
ootServicesCode=20
and EfiBootServicesData to virtual address.

As Matt's point out, the second things need to check is why does paging=
 fault
happen on physical address after SetVirtualAddressMap().

Currently, the only clue is we call QueryVariableInfo() in boottime for=
 grab the space
information of EFI_VARIABLE_BOOTSERVICE_ACCESS, but it should permitted=
 because it's=20
in boot time:

=E6=96=BC =E4=BA=94=EF=BC=8C2013-05-24 =E6=96=BC 08:43 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
>         status =3D efi_call_phys4(sys_table->runtime->query_variable_=
info,
>                                 EFI_VARIABLE_NON_VOLATILE |
>                                 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>                                 EFI_VARIABLE_RUNTIME_ACCESS, &store_s=
ize,
>                                 &remaining_size, &var_size);=20

Thanks a lot!
Joey Lee
