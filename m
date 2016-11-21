From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Mon, 21 Nov 2016 15:25:46 +0000
Message-ID: <891BA2BC-CF94-429C-B452-162EC9A0D6B7@linaro.org>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk> <20161117123731.GA11573@wunner.de> <29779.1479728545@warthog.procyon.org.uk> <CAKv+Gu-frVDhzORDRZ6XT+FxewsTgrxhXmM=DqaS6Ns4mJhQ9g@mail.gmail.com> <5701.1479732075@warthog.procyon.org.uk> <CAKv+Gu8Lhm=u97hY1y+Y+Ladk=y7pSVNrow8ML1hQUJ9+74B-w@mail.gmail.com> <20161121151758.GA1319@wunner.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161121151758.GA1319@wunner.de>
Sender: owner-linux-security-module@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: David Howells <dhowells@redhat.com>, Linn Crosetto <linn@hpe.com>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org


> On 21 Nov 2016, at 15:17, Lukas Wunner <lukas@wunner.de> wrote:
>=20
>> On Mon, Nov 21, 2016 at 01:14:52PM +0000, Ard Biesheuvel wrote:
>>> On 21 November 2016 at 12:41, David Howells <dhowells@redhat.com> wrote:=

>>> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>>> Looking in efi_get_secureboot(), is there a reason:
>>>>>=20
>>>>>        efi_guid_t var_guid =3D EFI_GLOBAL_VARIABLE_GUID;
>>>>>=20
>>>>> isn't static const?
>>>>=20
>>>> Not a good one, no. It used to be static const, but for some reason,
>>>> commit 30d7bf034c03 ("efi/arm64: Check SetupMode when determining
>>>> Secure Boot status") removed the static and the const (and I reviewed
>>>> it and did not complain AFAIR)
>>>> I'll gladly take a patch that reinstates that, though.
>>>=20
>>> Also, is there a reason that:
>>>=20
>>> typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *=
vendor, u32 *attr,
>>>                                         unsigned long *data_size, void *=
data);
>>>=20
>>> Doesn't have const name and vendor?
>>=20
>> Yes, but not a good one either.
>>=20
>> Sadly, the prototypes in the UEFI spec completely ignore constness,
>> and these definitions are intended to be identical to the ones in the
>> spec. This also means, for instance, that most UEFI firmwares stores
>> these kinds of GUIDs in read-write memory, which is a potential
>> goldmine for hackers, given how GUIDs are UEFI's duct tape, i.e.,
>> keeping the world together.
>=20
> But the spec declares these two parameters as "IN", so it would seem
> legal to declare them const, no?
>=20

Good point.

> Incidentally I've already prepared commits a couple of days ago to
> change the GUID declarations to const everywhere and also change the
> get_variable prototype, I was planning to submit them for 4.11... :-)
>=20

I would like to take those, provided that they only modify IN pointer argume=
nts.=
