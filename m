From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Tue, 2 Apr 2019 18:11:44 -0300
Message-ID: <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org


On 4/2/19 4:36 PM, Matthew Garrett wrote:
> On Tue, Apr 2, 2019 at 11:15 AM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>> 1. Enable efivarfs by selecting CONFIG_EFI in the CONFIG_OPAL_SECVAR
>>    introduced in this patch set. With CONFIG_EFIVAR_FS, userspace tools can
>>    be used to manage the secure variables.
> efivarfs has some pretty significant behavioural semantics that
> directly reflect the EFI specification. Using it to expose non-EFI
> variable data feels like it's going to increase fragility - there's a
> risk that we'll change things in a way that makes sense for the EFI
> spec but breaks your use case. Is the desire to use efivarfs to
> maintain consistency with existing userland tooling, or just to avoid
> having a separate filesystem?
>
We want to use the efivarfs for compatibility with existing userspace
tools. We will track and match any EFI changes that affect us.

Our use case is restricted to secure boot - this is not going to be a
general purpose EFI variable implementation.

Claudio
