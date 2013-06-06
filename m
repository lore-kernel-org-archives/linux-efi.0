From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Thu, 06 Jun 2013 10:24:20 +0800
Message-ID: <1370485460.6523.30.camel@linux-s257.site>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
	 <1370448519.6315.36.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370448519.6315.36.camel@x230.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt@console-pimps.org>, "Fleming, Matt" <matt.fleming@intel.com>, "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@linux.intel.com" <hpa@linux.intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "oneukum@suse.de" <oneukum@suse.de>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-06-05 =E6=96=BC 16:08 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 2013-06-05 at 16:59 +0100, Matt Fleming wrote:
>=20
> > +	/* clean DUMMY object */
> > +	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
>=20
> Hm. Actually, is that going to work? From the spec:
>=20

The patch I tested on OVMF, it can delete DUMMY object when system boot=
=2E

> If a preexisting variable is rewritten with different attributes,
> SetVariable()shall not modify the variable and shall return
> EFI_INVALID_PARAMETER.=20
>=20
> So I think we probably need to fix the attributes to NV|RT|BS for bot=
h
> this call and the one in query_variable_store. We should probably als=
o
> only do the workaround if the NV bit is set in the original query.
>=20
> --=20
> Matthew Garrett | mjg59@srcf.ucam.org

Yes, I think that more safe for fix the attributes.


Thanks a lot!
Joey Lee
