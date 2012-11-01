From: joeyli <jlee@suse.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 01 Nov 2012 12:21:55 +0800
Message-ID: <1351743715.21227.95.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	 <20121029174131.GC7580@srcf.ucam.org> <s5hobjia6vj.wl%tiwai@suse.de>
	 <20121031173728.GA18615@srcf.ucam.org>  <s5h390utqv3.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <s5h390utqv3.wl%tiwai@suse.de>
Sender: linux-security-module-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2012-10-31 =E6=96=BC 19:53 +0100=EF=BC=8CTa=
kashi Iwai =E6=8F=90=E5=88=B0=EF=BC=9A
> At Wed, 31 Oct 2012 17:37:28 +0000,
> Matthew Garrett wrote:
> >=20
> > On Wed, Oct 31, 2012 at 06:28:16PM +0100, Takashi Iwai wrote:
> >=20
> > > request_firmware() is used for microcode loading, too, so it's fa=
irly
> > > a core part to cover, I'm afraid.
> > >=20
> > > I played a bit about this yesterday.  The patch below is a proof =
of
> > > concept to (ab)use the module signing mechanism for firmware load=
ing
> > > too.  Sign firmware files via scripts/sign-file, and put to
> > > /lib/firmware/signed directory.
> >=20
> > That does still leave me a little uneasy as far as the microcode=20
> > licenses go. I don't know that we can distribute signed copies of s=
ome=20
> > of them, and we obviously can't sign at the user end.
>=20
> Yeah, that's a concern.  Although this is a sort of "container" and
> keeping the original data as is, it might be regarded as a
> modification.
>=20
> Another approach would be to a signature in a separate file, but I'm
> not sure whether it makes sense.
>=20

I think it make sense because the private key is still protected by
signer. Any hacker who modified firmware is still need use private key
to generate signature, but hacker's private key is impossible to match
with the public key that kernel used to verify firmware.

And, I afraid we have no choice that we need put the firmware signature
in a separate file. Contacting with those company's legal department
will be very time-consuming, and I am not sure all company will agree w=
e
put the signature with firmware then distribute.


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
