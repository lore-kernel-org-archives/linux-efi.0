From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Mon, 21 Nov 2016 13:14:52 +0000
Message-ID: <CAKv+Gu8Lhm=u97hY1y+Y+Ladk=y7pSVNrow8ML1hQUJ9+74B-w@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
 <20161117123731.GA11573@wunner.de> <29779.1479728545@warthog.procyon.org.uk>
 <CAKv+Gu-frVDhzORDRZ6XT+FxewsTgrxhXmM=DqaS6Ns4mJhQ9g@mail.gmail.com> <5701.1479732075@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5701.1479732075@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linn Crosetto <linn@hpe.com>, Lukas Wunner <lukas@wunner.de>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 21 November 2016 at 12:41, David Howells <dhowells@redhat.com> wrote:
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> > Looking in efi_get_secureboot(), is there a reason:
>> >
>> >         efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
>> >
>> > isn't static const?
>> >
>>
>> Not a good one, no. It used to be static const, but for some reason,
>> commit 30d7bf034c03 ("efi/arm64: Check SetupMode when determining
>> Secure Boot status") removed the static and the const (and I reviewed
>> it and did not complain AFAIR)
>> I'll gladly take a patch that reinstates that, though.
>
> Also, is there a reason that:
>
> typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
>                                          unsigned long *data_size, void *data);
>
> Doesn't have const name and vendor?
>

Yes, but not a good one either.

Sadly, the prototypes in the UEFI spec completely ignore constness,
and these definitions are intended to be identical to the ones in the
spec. This also means, for instance, that most UEFI firmwares stores
these kinds of GUIDs in read-write memory, which is a potential
goldmine for hackers, given how GUIDs are UEFI's duct tape, i.e.,
keeping the world together.
