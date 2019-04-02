From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Tue, 2 Apr 2019 20:31:19 -0300
Message-ID: <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
 <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org


On 4/2/19 6:51 PM, Matthew Garrett wrote:
> On Tue, Apr 2, 2019 at 2:11 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>> We want to use the efivarfs for compatibility with existing userspace
>> tools. We will track and match any EFI changes that affect us.
> So you implement the full PK/KEK/db/dbx/dbt infrastructure, and
> updates are signed in the same way?

For the first version, our firmware will implement a simplistic PK, KEK and
db infrastructure (without dbx and dbt) where only the Setup and User modes
will be supported.

PK, KEK and db updates will be signed the same way, that is, using
userspace tooling like efitools in PowerNV. As for the authentication
descriptors, only the EFI_VARIABLE_AUTHENTICATION_2 descriptor will be
supported.


>> Our use case is restricted to secure boot - this is not going to be a
>> general purpose EFI variable implementation.
> In that case we might be better off with a generic interface for this
> purpose that we can expose on all platforms that implement a secure
> boot key hierarchy. Having an efivarfs that doesn't allow the creation
> of arbitrary attributes may break other existing userland
> expectations.
>
For what it's worth, gsmi uses the efivars infrastructure for EFI-like
variables.

What might a generic interface look like?  It would have to work for
existing secure boot solutions - including EFI - which would seem to imply
changes to userspace tools.

Claudio
