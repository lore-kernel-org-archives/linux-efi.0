From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Fri, 10 May 2019 18:31:12 -0300
Message-ID: <e845d9f5-00bb-e68d-9d24-da802dd05549@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
 <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com>
 <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
 <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
 <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
 <CACdnJuvpUKiX5UgSOrzh+B9y68zKm+Bzu1c8KFJHd8diz=sm2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuvpUKiX5UgSOrzh+B9y68zKm+Bzu1c8KFJHd8diz=sm2Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hi Matthew,

Thanks for the feedback and sorry for the delay in responding.


On 4/10/19 2:36 PM, Matthew Garrett wrote:
> (Cc:ing Peter Jones)
>
> On Tue, Apr 9, 2019 at 3:55 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>>
>> On 4/5/19 7:19 PM, Matthew Garrett wrote:
>>> Based on our experience doing this in UEFI, that's insufficient - you
>>> want to be able to block individual binaries or leaf certificates
>>> without dropping trust in an intermediate certificate entirely.
>>
>> We agree that a dbx would be useful for blacklisting particular kernels
>> signed with given certificate. However, we have been avoiding doing so for
>> the initial release of secure boot on OpenPOWER. We don't have individual
>> firmware binaries in OpenPOWER. Kernels are currently the only concern for
>> the OS secure boot certificates we're discussing here. Also, we have a very
>> limited keystore space in POWER9.
>>
>> Petitboot doesn't have standardized OS kernel verification at all right
>> now.  Having the capability even without dbx seems valuable.
> I don't see the benefit in attempting to maintain compatibility with
> existing tooling unless you're going to be *completely* compatible
> with existing tooling. That means supporting dbx and dbt.


Before addressing that, I'd like to share some of the current OpenPOWER
secure boot design.
Different from UEFI, secure boot in OpenPOWER systems have two distinct
domains. Each one has its own key hierarchy and signing and signature
verification mechanisms.

In the firmware secure boot domain (work already upstream):
 - Every image loaded up to skiroot is wrapped in a secure boot container.
Skiroot is a Linux zimage with petitboot (kexec bootloader) embedded in the
initramfs.
 - Within the secure boot container, the payload image is protected by a
chain of signatures anchored in the root ECDSA keys, also known as hardware
keys.
 - All public keys required to verify the container are stored in the
container itself, but a hash of the trusted public hardware keys is stored
in a protected SEEPROM region outside of the container. Firmware uses it to
check if the container is anchored in the trusted hardware keys. If not,
the container payload is not executed and the boot is aborted.
 - The hash of the hardware keys is set by the firmware supplier, for
instance, the platform manufacturer.

In OS secure boot domain (work in progress):
- The skiroot container is verified as part of firmware secure boot.
- Skiroot uses UEFI-like secure variables (PK, KEK and db) to verify OS
kernels. Only X.509 certificates will be supported for these secure variables.
- OS kernels are signed using the Linux kernel sign-file tool, as if they
were kernel modules.
- In the skiroot kernel, if secure boot is enabled, the db certificates
will be loaded into the platform keyring and IMA-appraisal will verify the
kexec image against the platform keyring.
- The PK is set by whoever controls the platform, for instance, the
manufacturer or the end customer.

How about dbx and dbt?

The db keys will be used to verify only OS kernels via kexecs initiated by
petitboot. So we only need the dbx to revoke kernel images, either via
certs or hashes. Currently, the kernel loads certs and hashes from the dbx
to the system blacklist keyring. The revoked certs are checked during pkcs7
signature verification and loading of keys. However, there doesn't appear
to be any verification against blacklisted hashes. Should kernel images be
revoked only by keys and not hashes? We tried to find published revoked
kernel lists but couldn't find any. How is kernel image revocation handled
in practice?

Also, we didn't see the shim or kernel loading anything from dbt.

In general, how do you think the kernel ought to support blacklists?


>
>>>> The API is still a work in progress.  We are planning to publish a document
>>>> describing the current API and overall design shortly.
>>> Ok. How are the attributes interpreted by the API?
>>
>> We support a subset of standard EFI variable attributes, and we only use
>> EFI variables that relate to secure boot. Our goal is not to implement
>> UEFI.  However, we do seek to be compatible with user space tooling and
>> reuse as much existing infrastructure as possible. We don’t support the
>> following: EFI_VARIABLE_HARDWARE_ERROR_RECORD,
>> EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS and
>> EFI_VARIABLE_ENHANCED_AUTHENTICATED_ACCESS.
> Ok. I think that's realistically fine.
>
>>>> Perhaps the biggest departure is that the secure variables are stored in
>>>> flash memory that is not lockable.  In order to protect the secure
>>>> variables, hashes of the flash regions where they're stored are written to
>>>> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
>>>> runtime.  The sysadmin enqueues update commands in flash.  During the next
>>>> boot, the firmware verifies and processes the commands to update the
>>>> certificate store and accompanying integrity hashes in the TPM NVRAM
>>>> indices and write locks them.  Before certificates read from flash are
>>>> used, the certificate store is hashed and compared against the hashes
>>>> stored from the TPM.  The one exception is the PK. We store it in a TPM
>>>> NVRAM index by itself rather than flash because updates to it must be
>>>> guaranteed to be atomic.
>>> What's the behaviour if multiple updates are enqueued? Does reading
>>> back show a mocked up updated variable or the original state?
>>
>> Our secure variable updates are only applied at boot time. If any one of
>> them fails, they all fail.
> So I do the following:
>
> 1) Boot
> 2) Extend the contents of db
> 3) Extend the contents of db again
> 4) Read back the contents of db through efivarfs
> 5) Reboot
> 6) Read back the contents of db through efivarfs
>
> Is what I see in (4) and (6) the same? Does it contain the values form
> both extensions?

In (2) and (3) the extensions are added to the update queue, which is
processed only in (5) by firmware. So, in (4) you should see the db content
without the extensions.
In (5), firmware (skiboot) will process the update queue. The extensions
will be applied only if *all* of them are valid and pass signature
verification. Only in this case should you be able to see the extensions in
(6). If any of the extensions fail, firmware will discard all of them,
clear the queue, and do the proper logging.


>>> I'm not really clear on the workflow here. Who's the administrator
>>> authority? When would they be updating the second level of keys? If
>>> there's no support for revocation, why would distributions need two
>>> levels of key in the system database rather than just distributing a
>>> single intermediate and signing their actual signing certs with that?
>>
>> In OpenPOWER systems, we enable our customers and business partners to
>> establish and manage the platform key certificate, which is the root of our
>> key hierarchy. From there, through the KEK, they can delegate authority to
>> intermediate level organizations, e.g. distros or IT departments or
>> business operations. Those intermediate level organizations then manage the
>> code signing certificates in the DB. If this answer doesn’t address your
>> question, can you please rephrase?
> Why would the intermediate level organisations not just have entries
> in db?

Because that seems to add more complexity than having three levels (PK, KEK
and db).

Typically, the intermediate level organisations (or KEK) are used to
authorize new additions to db. However, if we also have them in the db, who
would authorize the new additions to db. If that would be the intermediate
level organisation entries now in the db, it seems we would need to
implement a mechanism to determine which entries are for authorizing new
additions and which are for kernel signature verification. If that would be
the PK, we'd be burdening the PK owner to sign every new db addition if the
platform is owned by a company that has intermediate level organizations.


>  The main reason we don't do it this way in UEFI is because we
> need to support dbx, and if you're not supporting dbx I'm not sure I
> see the benefit.

I'm not sure I understand your question.  We would be using dbx to prevent
kernels from being loaded. How is that related to having three levels in
the key hierarchy (PK, KEK and db)?

Thanks,
Claudio
