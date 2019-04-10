From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Wed, 10 Apr 2019 10:36:36 -0700
Message-ID: <CACdnJuvpUKiX5UgSOrzh+B9y68zKm+Bzu1c8KFJHd8diz=sm2Q@mail.gmail.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com> <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com> <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com> <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
 <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Claudio Carvalho <cclaudio@linux.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

(Cc:ing Peter Jones)

On Tue, Apr 9, 2019 at 3:55 PM Claudio Carvalho <cclaudio@linux.ibm.com> wr=
ote:
>
>
> On 4/5/19 7:19 PM, Matthew Garrett wrote:
> > Based on our experience doing this in UEFI, that's insufficient - you
> > want to be able to block individual binaries or leaf certificates
> > without dropping trust in an intermediate certificate entirely.
>
>
> We agree that a dbx would be useful for blacklisting particular kernels
> signed with given certificate. However, we have been avoiding doing so fo=
r
> the initial release of secure boot on OpenPOWER. We don't have individual
> firmware binaries in OpenPOWER. Kernels are currently the only concern fo=
r
> the OS secure boot certificates we're discussing here. Also, we have a ve=
ry
> limited keystore space in POWER9.
>
> Petitboot doesn't have standardized OS kernel verification at all right
> now.  Having the capability even without dbx seems valuable.

I don't see the benefit in attempting to maintain compatibility with
existing tooling unless you're going to be *completely* compatible
with existing tooling. That means supporting dbx and dbt.

> >> The API is still a work in progress.  We are planning to publish a doc=
ument
> >> describing the current API and overall design shortly.
> > Ok. How are the attributes interpreted by the API?
>
>
> We support a subset of standard EFI variable attributes, and we only use
> EFI variables that relate to secure boot. Our goal is not to implement
> UEFI.  However, we do seek to be compatible with user space tooling and
> reuse as much existing infrastructure as possible. We don=E2=80=99t suppo=
rt the
> following: EFI_VARIABLE_HARDWARE_ERROR_RECORD,
> EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS and
> EFI_VARIABLE_ENHANCED_AUTHENTICATED_ACCESS.

Ok. I think that's realistically fine.

>
> >
> >> Perhaps the biggest departure is that the secure variables are stored =
in
> >> flash memory that is not lockable.  In order to protect the secure
> >> variables, hashes of the flash regions where they're stored are writte=
n to
> >> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
> >> runtime.  The sysadmin enqueues update commands in flash.  During the =
next
> >> boot, the firmware verifies and processes the commands to update the
> >> certificate store and accompanying integrity hashes in the TPM NVRAM
> >> indices and write locks them.  Before certificates read from flash are
> >> used, the certificate store is hashed and compared against the hashes
> >> stored from the TPM.  The one exception is the PK. We store it in a TP=
M
> >> NVRAM index by itself rather than flash because updates to it must be
> >> guaranteed to be atomic.
> > What's the behaviour if multiple updates are enqueued? Does reading
> > back show a mocked up updated variable or the original state?
>
>
> Our secure variable updates are only applied at boot time. If any one of
> them fails, they all fail.

So I do the following:

1) Boot
2) Extend the contents of db
3) Extend the contents of db again
4) Read back the contents of db through efivarfs
5) Reboot
6) Read back the contents of db through efivarfs

Is what I see in (4) and (6) the same? Does it contain the values form
both extensions?

> > I'm not really clear on the workflow here. Who's the administrator
> > authority? When would they be updating the second level of keys? If
> > there's no support for revocation, why would distributions need two
> > levels of key in the system database rather than just distributing a
> > single intermediate and signing their actual signing certs with that?
>
>
> In OpenPOWER systems, we enable our customers and business partners to
> establish and manage the platform key certificate, which is the root of o=
ur
> key hierarchy. From there, through the KEK, they can delegate authority t=
o
> intermediate level organizations, e.g. distros or IT departments or
> business operations. Those intermediate level organizations then manage t=
he
> code signing certificates in the DB. If this answer doesn=E2=80=99t addre=
ss your
> question, can you please rephrase?

Why would the intermediate level organisations not just have entries
in db? The main reason we don't do it this way in UEFI is because we
need to support dbx, and if you're not supporting dbx I'm not sure I
see the benefit.
