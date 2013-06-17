From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Mon, 17 Jun 2013 10:21:07 +0100
Message-ID: <20130617092107.GA5440@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371139233.6523.272.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Jun, at 12:00:33AM, joeyli wrote:
> Hi Zach,=20
>=20
> =E6=96=BC =E4=BA=8C=EF=BC=8C2013-06-11 =E6=96=BC 07:52 +0100=EF=BC=8C=
Matt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> > From: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>
> >=20
> > ExitBootServices is absolutely supposed to return a failure if any
> > ExitBootServices event handler changes the memory map.  Basically t=
he
> > get_map loop should run again if ExitBootServices returns an error =
the
> > first time.  I would say it would be fair that if ExitBootServices =
gives
> > an error the second time then Linux would be fine in returning cont=
rol
> > back to BIOS.
> >=20
> > The second change is the following line:
> >=20
> > again:
> >         size +=3D sizeof(*mem_map) * 2;
> >=20
> > Originally you were incrementing it by the size of one memory map e=
ntry.
> > The issue here is all related to the low_alloc routine you are usin=
g.
> > In this routine you are making allocations to get the memory map it=
self.
> > Doing this allocation or allocations can affect the memory map by m=
ore
> > than one record.
> >=20
> > [ mfleming - changelog, code style ]
> > Signed-off-by: Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compr=
essed/eboot.c
> > index 35ee62f..7c6e5d9 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -1037,18 +1037,20 @@ static efi_status_t exit_boot(struct boot_p=
arams *boot_params,
> >  	efi_memory_desc_t *mem_map;
> >  	efi_status_t status;
> >  	__u32 desc_version;
> > +	bool called_exit =3D false;
> >  	u8 nr_entries;
> >  	int i;
> > =20
> >  	size =3D sizeof(*mem_map) * 32;
> > =20
> >  again:
> > -	size +=3D sizeof(*mem_map);
> > +	size +=3D sizeof(*mem_map) * 2;
> >  	_size =3D size;
> >  	status =3D low_alloc(size, 1, (unsigned long *)&mem_map);
>=20
> Can we know why increased the size of double *mem_map is big enough?
> Does there have any real guarantee to be sufficient?
=20
It's not guaranteed to be sufficient, it's simply a best guess. If we
haven't allocated enough memory to store the memory map we should loop
around to the 'again' label anyway. It's just an optimisation, right
Zach?

> And, why would doubling the increment be necessary here, but not in
> __get_map()?
=20
Again, we'll grow the map if it isn't large enough.

> >  	if (status !=3D EFI_SUCCESS)
> >  		return status;
> > =20
> > +get_map:
>=20
> The get_map label is being placed such that the size doesn't
> get adjusted anymore, yet it is supposed to deal with an allocation
> having happened during ExitBootServices(), which could have
> grown the map.
>=20
> Why doesn't direct goto 'again' label?
=20
It makes more sense to query GetMemoryMap() directly first to get the
required size of the memory map. Then we jump to 'again' and allocate
the correct size.

> >  	status =3D efi_call_phys5(sys_table->boottime->get_memory_map, &s=
ize,
> >  				mem_map, &key, &desc_size, &desc_version);
> >  	if (status =3D=3D EFI_BUFFER_TOO_SMALL) {
> > @@ -1074,8 +1076,20 @@ again:
> >  	/* Might as well exit boot services now */
> >  	status =3D efi_call_phys2(sys_table->boottime->exit_boot_services=
,
> >  				handle, key);
> > -	if (status !=3D EFI_SUCCESS)
> > -		goto free_mem_map;
> > +	if (status !=3D EFI_SUCCESS) {
> > +		/*
> > +		 * ExitBootServices() will fail if any of the event
> > +		 * handlers change the memory map. In which case, we
> > +		 * must be prepared to retry, but only once so that
> > +		 * we're guaranteed to exit on repeated failures instead
> > +		 * of spinning forever.
> > +		 */
> > +		if (called_exit)
> > +			goto free_mem_map;
> > +
> > +		called_exit =3D true;
>=20
> Why a single retry is having reasonable guarantees to work when the
> original one failed (nothing prevents an event handler to do another
> allocation the next time through).
>=20
> Why not retry 3, 4, 5 or even unlimited times?
=20
There has to be an upper limit on the number of retries. It seems fair
to retry once but any more than that and it's more likely that there's =
a
serious problem and we should bail.

--=20
Matt Fleming, Intel Open Source Technology Center
