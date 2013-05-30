From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Thu, 30 May 2013 10:16:12 +0800
Message-ID: <1369880172.17397.11.camel@linux-s257.site>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1305300048520.30576-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-05-30 =E6=96=BC 00:53 +0200=EF=BC=8CJi=
ri Kosina =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 29 May 2013, Russ Anderson wrote:
>=20
> > > Yes, but this call is clearly happening way before ExitBootServic=
es() --=20
> > > see the surrounding code, see for example this in efi_main():
> > >=20
> > > [ ... snip ... ]
> > > 	setup_efi_vars(boot_params);
> > >=20
> > > 	setup_efi_pci(boot_params);
> > >=20
> > > 	status =3D efi_call_phys3(sys_table->boottime->allocate_pool,
> > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > 				(void **)&gdt);
> > > 	if (status !=3D EFI_SUCCESS) {
> > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > 		goto fail;
> > > 	}
> > > [ ... snip ... ]
> >=20
> > Yes.  Note the failing call is sys_table->runtime while all the
> > other calls are sys_table->boottime and seem to work.  Not sure
> > why the sys_table->runtime call has a problem but it may be
> > a clue.  Could something in the runtime path not be set up???
>=20
> That was my original idea early today as well. My understanding of th=
e=20
> UEFI spec is admittedly limited, but afaics calling runtime method fr=
om=20
> boot environment should be a valid thing to do ... ?

QueryVariableInfo() is a runtime services, all runtime services should
available bother on boot time and runtime:

UEFI spec 2.3.1 P.109:
  Runtime Services
  Functions that are available before and after any call to =20
  ExitBootServices(). These functions are described in Section 7.

>=20
> > > We are calling QueryVariableInfo() in setup_efi_vars(), and later=
 on=20
> > > AllocatePool is being called (through boot table).
> >=20
> > On my system the QueryVariableInfo() call fails, so AllocatePool()
> > is not called in setup_efi_vars().
>=20
> But it's being called later on coming back to efi_main(). That was ju=
st a=20
> poor man's demonstration attempt why this code is running before=20
> ExitBootServices() has been called.
>=20

Yes, I agreed your point, the space information of
EFI_VARIABLE_BOOTSERVICE_ACCESS should still return by
QueryVariableInfo() because we call it before ExitBootServices():

arch/x86/boot/compressed/eboot.c
efi_main(void *handle, efi_system_table_t *_table, struct boot_params *=
boot_params)
	..
	sys_table =3D _table;
	/* Check if we were booted by the EFI firmware */
	if (sys_table->hdr.signature !=3D EFI_SYSTEM_TABLE_SIGNATURE)
		goto fail;
	boot_params->secure_boot =3D get_secure_boot(sys_table)			/* check doe=
s BIOS in secure boot mode */
	setup_graphics(boot_params);
	setup_efi_vars(boot_params);						/* Pass boot services variable info =
to runtime code, call QueryVariableInfo() */
	...
	status =3D exit_boot(boot_params, handle);				/* call ExitBootServices=
() */
	...


Thanks a lot!
Joey Lee
