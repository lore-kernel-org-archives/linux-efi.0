From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Wed, 3 Apr 2019 18:48:39 -0300
Message-ID: <3befcee7-0b65-c312-1f14-daa56afeb176@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <87r2aj1ayf.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r2aj1ayf.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org


On 4/3/19 10:21 AM, Michael Ellerman wrote:
> Hi Claudio,
>
> Thanks for posting this.
>
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> This patch set is part of a series that implements secure boot on
>> PowerNV systems.
>>
>> In order to verify the OS kernel on PowerNV, secure boot requires X.509
>> certificates trusted by the platform, the secure boot modes, and several
>> other pieces of information. These are stored in secure variables
>> controlled by OPAL, also known as OPAL secure variables.
>>
>> This patch set adds the following features:
>>
>> 1. Enable efivarfs by selecting CONFIG_EFI in the CONFIG_OPAL_SECVAR
>>    introduced in this patch set. With CONFIG_EFIVAR_FS, userspace tools can
>>    be used to manage the secure variables.
>> 2. Add support for OPAL secure variables by overwriting the EFI hooks
>>    (get_variable, get_next_variable, set_variable and query_variable_info)
>>    with OPAL call wrappers. There is probably a better way to add this
>>    support, for example, we are investigating if we could register the
>>    efivar_operations rather than overwriting the EFI hooks. In this patch
>>    set, CONFIG_OPAL_SECVAR selects CONFIG_EFI. If, instead, we registered
>>    efivar_operations, CONFIG_EFIVAR_FS would need to depend on
>>    CONFIG_EFI|| CONFIG_OPAL_SECVAR. Comments or suggestions on the
>>    preferred technique would be greatly appreciated.
> I am *very* reluctant to start selecting CONFIG_EFI on powerpc.
>
> Simply because we don't actually have EFI, and I worry we're going to
> both break assumptions in the EFI code as well as impose requirements on
> the powerpc code that aren't really necessary.

Yes, we agree. We are working on the v2 and it is not going to depend on
CONFIG_EFI. Rather, the IMA arch policies will make the OPAL calls directly.


>
> So I'd definitely prefer we go the route of enabling efivarfs with an
> alternate backend.

Right, I'm investigating how we can do that, but it looks like we should
post that as a separate patchset to avoid delaying upstreaming signature
verification based on the secure boot variables.

Thanks,
Claudio


>
> Better still would be a generic secure variable interface as Matt
> suggests, if the userspace tools can be relatively easily adapted to use
> that interface.
>
> cheers
>
