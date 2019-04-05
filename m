From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Fri, 5 Apr 2019 15:19:07 -0700
Message-ID: <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com> <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com> <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Claudio Carvalho <cclaudio@linux.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 5, 2019 at 2:11 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>
>
> On 4/3/19 7:27 PM, Matthew Garrett wrote:
> > Not supporting dbx seems like a pretty significant shortcoming. How
> > are signatures meant to be revoked?
>
>
> We began by focusing on certificates for keys that can be added at
> runtime.  Before adding support for revocation, we plan to gather
> additional use cases.  In the meantime, unwanted certificates can be
> removed by the administrator.

Based on our experience doing this in UEFI, that's insufficient - you
want to be able to block individual binaries or leaf certificates
without dropping trust in an intermediate certificate entirely.

>
> >
> >> PK, KEK and db updates will be signed the same way, that is, using
> >> userspace tooling like efitools in PowerNV. As for the authentication
> >> descriptors, only the EFI_VARIABLE_AUTHENTICATION_2 descriptor will be
> >> supported.
> > Is this API documented?
>
>
> The API is still a work in progress.  We are planning to publish a document
> describing the current API and overall design shortly.

Ok. How are the attributes interpreted by the API?

> Perhaps the biggest departure is that the secure variables are stored in
> flash memory that is not lockable.  In order to protect the secure
> variables, hashes of the flash regions where they're stored are written to
> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
> runtime.  The sysadmin enqueues update commands in flash.  During the next
> boot, the firmware verifies and processes the commands to update the
> certificate store and accompanying integrity hashes in the TPM NVRAM
> indices and write locks them.  Before certificates read from flash are
> used, the certificate store is hashed and compared against the hashes
> stored from the TPM.  The one exception is the PK. We store it in a TPM
> NVRAM index by itself rather than flash because updates to it must be
> guaranteed to be atomic.

What's the behaviour if multiple updates are enqueued? Does reading
back show a mocked up updated variable or the original state?

> > I think that depends on exactly what problem you're trying to solve.
> > Some aspects of the EFI secure boot design end up mirroring the
> > economics of the PC ecosystem rather than being inherently good design
> > goals, so it'd be helpful to know whether you're taking this solution
> > because you want the same three-level key infrastructure or because
> > that just leaves you compatible with the tooling.
>
>
> In our use case,  the three-level key hierarchy conveniently supports the
> concept of (1) an administrator authority, who authorizes (2) other
> organizations, e.g., distros, to provide (3) certificates for their code
> signing keys.   By using efivars, we leverage pre-existing userspace EFI
> tools to generate authenticated updates and certificates.  Additionally,
> pre-existing kernel infrastructure simplifies efivars processing.

I'm not really clear on the workflow here. Who's the administrator
authority? When would they be updating the second level of keys? If
there's no support for revocation, why would distributions need two
levels of key in the system database rather than just distributing a
single intermediate and signing their actual signing certs with that?
